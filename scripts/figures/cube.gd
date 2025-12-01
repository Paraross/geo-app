class_name Cube
extends Figure

const VERTICES: Array[Vector3] = [
	# front
	Vector3(-1, 1, 1), # 1 left top near
	Vector3(1, 1, 1), # 2 right top near
	Vector3(1, -1, 1), # 6 right bottom near
	Vector3(-1, -1, 1), # 5 left bottom near
	# back
	Vector3(-1, 1, -1), # 0 left top far
	Vector3(1, 1, -1), # 3 right top far
	Vector3(1, -1, -1), # 7 right bottom far
	Vector3(-1, -1, -1), # 4 left bottom far
	# alt back
	# Vector3(1, 1, -1), # 3 right top far
	# Vector3(-1, 1, -1), # 0 left top far
	# Vector3(-1, -1, -1), # 4 left bottom far
	# Vector3(1, -1, -1), # 7 right bottom far
]

var edges1: Array[Edge] = [
	# front
	Edge.new(0, 1),
	Edge.new(1, 2),
	Edge.new(2, 3),
	Edge.new(3, 0),
	# back
	Edge.new(4, 5),
	Edge.new(5, 6),
	Edge.new(6, 7),
	Edge.new(7, 4),
	# horizontal
	Edge.new(0, 4),
	Edge.new(1, 5),
	Edge.new(2, 6),
	Edge.new(3, 7),
]

var side_length: float:
	set(value):
		side_length = value
		set_mesh()
		update_collision_shape()
		properties_changed.emit()

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

	var verts := Poly.extract_faces(VERTICES)

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
	return vertex * side_length / 2.0


func vertices() -> Array[Vector3]:
	var verts: Array[Vector3] = VERTICES.duplicate()
	for i in range(verts.size()):
		verts[i] = scaled(verts[i])
	return verts


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
