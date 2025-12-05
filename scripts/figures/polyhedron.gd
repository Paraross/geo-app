class_name Polyhedron
extends Figure

@onready var shape: ConvexPolygonShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	super._ready()
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
