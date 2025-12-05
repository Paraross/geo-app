class_name Polyhedron
extends Figure

var vertex_spheres: Array[Sphere]
var edge_cylinders: Array[Cylinder]

@onready var shape: ConvexPolygonShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	var vertices := vertices()
	var vertex_sphere_scene: PackedScene = preload("res://scenes/figures/sphere.tscn")
	var vertex_sphere_mesh: SphereMesh = preload("res://assets/vertex_mesh.tres")

	for vertex_position in vertices:
		var vertex_sphere: Sphere = vertex_sphere_scene.instantiate()

		vertex_spheres.push_back(vertex_sphere)
		add_child(vertex_sphere)

		vertex_sphere.mesh_instance.mesh = vertex_sphere_mesh

		vertex_sphere.position = vertex_position
		vertex_sphere.radius = 0.05

	var edge_cylinder_scene: PackedScene = preload("res://scenes/figures/cylinder.tscn")
	var edge_cylinder_mesh: CylinderMesh = preload("res://assets/edge_mesh.tres")
	var edge_cylinder_shape: CylinderShape3D = preload("res://assets/edge_shape.tres")

	for edge in edges():
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_cylinder: Cylinder = edge_cylinder_scene.instantiate()

		edge_cylinders.push_back(edge_cylinder)
		add_child(edge_cylinder)

		edge_cylinder.mesh_instance.mesh = edge_cylinder_mesh.duplicate()
		edge_cylinder.collision_shape.shape = edge_cylinder_shape.duplicate()

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		edge_cylinder.height = start_vertex.distance_to(end_vertex)
		edge_cylinder.radius = 0.025
		edge_cylinder.transform = Transform3D(Basis(basis_right, basis_up, basis_forward), midpoint)

	connect_signals()

	set_mesh()
	set_collision_shape()



func set_mesh() -> void:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	var verts := Poly.extract_faces(normalized_vertices())

	# TODO: run this only once at ready, store normalized faces, then multiply when needed
	var flattened_faces := Poly.flatten_faces(verts)
	for i in range(flattened_faces.size()):
		flattened_faces[i] = scaled(flattened_faces[i])

	arrays[Mesh.ARRAY_VERTEX] = flattened_faces
	arrays[Mesh.ARRAY_NORMAL] = Poly.generate_normals(verts)
	arrays[Mesh.ARRAY_INDEX] = Poly.generate_indices(verts)

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh


func set_collision_shape() -> void:
	var cp_shape := ConvexPolygonShape3D.new()
	cp_shape.points = vertices()
	shape = cp_shape


func update_collision_shape() -> void:
	shape.points = vertices()


func connect_signals() -> void:
	properties_changed.connect(set_vertices)
	properties_changed.connect(set_edges)


func set_vertices() -> void:
	var vertices := vertices()
	for i in range(vertex_spheres.size()):
		var vertex_position := vertices[i]
		var vertex_mesh := vertex_spheres[i]
		vertex_mesh.position = vertex_position


func set_edges() -> void:
	var vertices := vertices()
	var edges := edges()
	for i in range(edge_cylinders.size()):
		var edge := edges[i]
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		# var edge_mesh: CylinderMesh = edge_cylinders[i].mesh_instance.mesh
		# edge_mesh.height = start_vertex.distance_to(end_vertex)
		edge_cylinders[i].height = start_vertex.distance_to(end_vertex)
		edge_cylinders[i].position = midpoint

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		var basis1 := Basis(basis_right, basis_up, basis_forward)
		edge_cylinders[i].transform = Transform3D(basis1, midpoint)


func scaled(vertex: Vector3) -> Vector3:
	assert(false, "shouldn't be called for now")
	return vertex


func vertices() -> Array[Vector3]:
	assert(false, "shouldn't be called for now")
	return []
	

func normalized_vertices() -> Array[Vector3]:
	assert(false, "shouldn't be called for now")
	return []


func edges() -> Array[Edge]:
	assert(false, "shouldn't be called for now")
	return []


func area() -> float:
	assert(false, "shouldn't be called for now")
	return 0.0


func volume() -> float:
	assert(false, "shouldn't be called for now")
	return 0.0
