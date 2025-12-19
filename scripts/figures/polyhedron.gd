class_name Polyhedron
extends Figure

var vertex_spheres: Array[Sphere]
var edge_cylinders: Array[Cylinder]

var vertices: PackedVector3Array
var faces_indices: Array[PackedInt32Array]

@onready var shape: ConvexPolygonShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	faces_indices = Poly.extract_faces_indices(vertices)

	create_vertex_spheres()
	create_edge_cylinders()

	connect_signals()

	set_mesh()
	set_collision_shape()


func update_vertices() -> void:
	clear_vertex_spheres_edge_cylinders()
	faces_indices = Poly.extract_faces_indices(vertices)
	create_vertex_spheres()
	create_edge_cylinders()

	set_mesh()
	set_collision_shape()


func set_mesh() -> void:
	if faces_indices.is_empty():
		return

	var face_verts: Array[PackedVector3Array] = []
	face_verts.resize(faces_indices.size())

	for i in range(faces_indices.size()):
		var face_indices := faces_indices[i]
		var face_vertices := PackedVector3Array()
		face_vertices.resize(face_indices.size())

		for j in range(face_indices.size()):
			face_vertices[j] = vertices[face_indices[j]]

		face_verts[i] = face_vertices

	# TODO: run this only once at ready, store normalized faces, then multiply when needed
	var flattened_faces := Poly.flatten_faces(face_verts)

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	arrays[Mesh.ARRAY_VERTEX] = flattened_faces
	arrays[Mesh.ARRAY_NORMAL] = Poly.generate_normals(face_verts)
	arrays[Mesh.ARRAY_INDEX] = Poly.generate_indices(face_verts)

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh


func set_collision_shape() -> void:
	var faces := Poly.extract_faces_indices(vertices)
	var edges := Poly.get_edges_from_faces(faces)

	# TODO: check which vertices are problematic (when adding new vertex in playground)

	# Euler's formula for polyhedrons
	var is_valid_polyhedron := vertices.size() - edges.size() + faces.size() == 2

	if is_valid_polyhedron:
		var cp_shape := ConvexPolygonShape3D.new()
		cp_shape.points = vertices
		shape = cp_shape
	else:
		print("invalid vertices")
		shape = null


func update_collision_shape() -> void:
	shape.points = vertices


func connect_signals() -> void:
	properties_changed.connect(set_mesh)
	properties_changed.connect(update_collision_shape)
	properties_changed.connect(set_vertex_spheres_transform)
	properties_changed.connect(set_edge_cylinders_transform)


func create_vertex_spheres() -> void:
	var vertex_sphere_scene: PackedScene = preload("res://scenes/figures/sphere.tscn")
	var vertex_sphere_mesh: SphereMesh = preload("res://assets/vertex_mesh.tres")

	for vertex_position in vertices:
		var vertex_sphere: Sphere = vertex_sphere_scene.instantiate()

		vertex_spheres.push_back(vertex_sphere)
		add_child(vertex_sphere)

		vertex_sphere.mesh_instance.mesh = vertex_sphere_mesh

		vertex_sphere.position = vertex_position
		vertex_sphere.radius = 0.05


func set_vertex_spheres_transform() -> void:
	for i in range(vertex_spheres.size()):
		var vertex_position := vertices[i]
		var vertex_mesh := vertex_spheres[i]
		vertex_mesh.position = vertex_position


func create_edge_cylinders() -> void:
	var edge_cylinder_scene: PackedScene = preload("res://scenes/figures/cylinder.tscn")
	var edge_cylinder_mesh: CylinderMesh = preload("res://assets/edge_mesh.tres")
	var edge_cylinder_shape: CylinderShape3D = preload("res://assets/edge_shape.tres")

	var middle_point := Vector3.ZERO
	for vertex in vertices:
		middle_point += vertex
	middle_point /= vertices.size()

	for edge in edges():
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_cylinder: Cylinder = edge_cylinder_scene.instantiate()

		edge_cylinders.push_back(edge_cylinder)
		add_child(edge_cylinder)

		edge_cylinder.mesh_instance.mesh = edge_cylinder_mesh.duplicate()
		edge_cylinder.collision_shape.shape = edge_cylinder_shape.duplicate()

		var basis_right := (midpoint - middle_point).normalized()
		if basis_right == Vector3.ZERO or basis_right.is_equal_approx(Vector3.ZERO):
			basis_right = Vector3.RIGHT

		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := basis_right.cross(basis_up).normalized()
		basis_right = basis_up.cross(basis_forward).normalized()

		edge_cylinder.height = start_vertex.distance_to(end_vertex)
		edge_cylinder.radius = 0.025
		edge_cylinder.transform = Transform3D(Basis(basis_right, basis_up, basis_forward), midpoint)


func set_edge_cylinders_transform() -> void:
	var middle_point := Vector3.ZERO
	for vertex in vertices:
		middle_point += vertex
	middle_point /= vertices.size()

	var edges := edges()
	for i in range(edge_cylinders.size()):
		var edge := edges[i]
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		edge_cylinders[i].height = start_vertex.distance_to(end_vertex)

		var basis_right := (midpoint - middle_point).normalized()
		if basis_right == Vector3.ZERO or basis_right.is_equal_approx(Vector3.ZERO):
			basis_right = Vector3.RIGHT

		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := basis_right.cross(basis_up).normalized()
		basis_right = basis_up.cross(basis_forward).normalized()

		edge_cylinders[i].transform = Transform3D(Basis(basis_right, basis_up, basis_forward), midpoint)


func clear_vertex_spheres_edge_cylinders() -> void:
	for vertex_sphere in vertex_spheres:
		vertex_sphere.queue_free()
		remove_child(vertex_sphere)
	vertex_spheres.clear()

	for edge_cylinder in edge_cylinders:
		edge_cylinder.queue_free()
		remove_child(edge_cylinder)
	edge_cylinders.clear()


func scale() -> Vector3:
	return Vector3.ONE


func edges() -> Array[Edge]:
	return Poly.get_edges_from_faces(faces_indices)


func area() -> float:
	var total_area := 0.0

	for face_indices in faces_indices:
		total_area += calculate_face_area(face_indices)

	return total_area


func calculate_face_area(face_indices: PackedInt32Array) -> float:
	var face_area := 0.0

	var triangle_count := face_indices.size() - 2
	# for each triangle in face
	for i in triangle_count:
		var index1 := 0 # Poly.triangle_index(i * 3)
		var index2 := Poly.triangle_index(i * 3 + 1)
		var index3 := index2 + 1 # Poly.triangle_index(i * 3 + 2)
		var face_index1 := face_indices[index1]
		var face_index2 := face_indices[index2]
		var face_index3 := face_indices[index3]
		var vertex1 := vertices[face_index1]
		var vertex2 := vertices[face_index2]
		var vertex3 := vertices[face_index3]

		var cross := (vertex2 - vertex1).cross(vertex3 - vertex1)
		var triangle_area := cross.length() / 2.0

		face_area += triangle_area

	return face_area


# https://en.wikipedia.org/wiki/Polyhedron#Volume
func volume() -> float:
	var total_volume := 0.0

	for face_indices in faces_indices:
		var vertex1 := vertices[face_indices[0]]
		var vertex2 := vertices[face_indices[1]]
		var vertex3 := vertices[face_indices[2]]

		var q := vertices[face_indices[0]]
		var n := (vertex3 - vertex1).cross(vertex2 - vertex1).normalized()
		var face_area := calculate_face_area(face_indices)

		var volume := q.dot(n) * face_area

		total_volume += volume

	return total_volume / 3.0
