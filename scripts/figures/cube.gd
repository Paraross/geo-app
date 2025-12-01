class_name Cube
extends Figure

const VERTICES: Array[Vector3] = [
	Vector3(-1, 1, -1), # left top far
	Vector3(-1, 1, 1), # left top near
	Vector3(1, 1, 1), # right top near
	Vector3(1, 1, -1), # right top far
	Vector3(-1, -1, -1), # left bottom far
	Vector3(-1, -1, 1), # left bottom near
	Vector3(1, -1, 1), # right bottom near
	Vector3(1, -1, -1), # right bottom far
]

var edges1: Array[Edge] = [
	# top
	Edge.new(0, 1),
	Edge.new(1, 2),
	Edge.new(2, 3),
	Edge.new(3, 0),
	# bottom
	Edge.new(4, 5),
	Edge.new(5, 6),
	Edge.new(6, 7),
	Edge.new(7, 4),
	# vertical
	Edge.new(0, 4),
	Edge.new(1, 5),
	Edge.new(2, 6),
	Edge.new(3, 7),
]

var side_length: float = 2.0:
	get:
		return _side_length
	set(value):
		_side_length = value
		var vec := Vector3(value, value, value)
		shape.size = vec
		_update_mesh()
		properties_changed.emit()

var _side_length: float = 2.0

@onready var shape: BoxShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	super._ready()
	_update_mesh()


func _update_mesh() -> void:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	var half_size := _side_length / 2.0

	# Define vertices for each face (4 vertices per face, 6 faces)
	var verts := PackedVector3Array([
		# Front face (z+)
		Vector3(-half_size, -half_size, half_size),
		Vector3(half_size, -half_size, half_size),
		Vector3(half_size, half_size, half_size),
		Vector3(-half_size, half_size, half_size),
		# Back face (z-)
		Vector3(half_size, -half_size, -half_size),
		Vector3(-half_size, -half_size, -half_size),
		Vector3(-half_size, half_size, -half_size),
		Vector3(half_size, half_size, -half_size),
		# Top face (y+)
		Vector3(-half_size, half_size, half_size),
		Vector3(half_size, half_size, half_size),
		Vector3(half_size, half_size, -half_size),
		Vector3(-half_size, half_size, -half_size),
		# Bottom face (y-)
		Vector3(-half_size, -half_size, -half_size),
		Vector3(half_size, -half_size, -half_size),
		Vector3(half_size, -half_size, half_size),
		Vector3(-half_size, -half_size, half_size),
		# Right face (x+)
		Vector3(half_size, -half_size, half_size),
		Vector3(half_size, -half_size, -half_size),
		Vector3(half_size, half_size, -half_size),
		Vector3(half_size, half_size, half_size),
		# Left face (x-)
		Vector3(-half_size, -half_size, -half_size),
		Vector3(-half_size, -half_size, half_size),
		Vector3(-half_size, half_size, half_size),
		Vector3(-half_size, half_size, -half_size),
	])

	# Define normals for each face
	var normals := PackedVector3Array([
		# Front
		Vector3(0, 0, 1), Vector3(0, 0, 1), Vector3(0, 0, 1), Vector3(0, 0, 1),
		# Back
		Vector3(0, 0, -1), Vector3(0, 0, -1), Vector3(0, 0, -1), Vector3(0, 0, -1),
		# Top
		Vector3(0, 1, 0), Vector3(0, 1, 0), Vector3(0, 1, 0), Vector3(0, 1, 0),
		# Bottom
		Vector3(0, -1, 0), Vector3(0, -1, 0), Vector3(0, -1, 0), Vector3(0, -1, 0),
		# Right
		Vector3(1, 0, 0), Vector3(1, 0, 0), Vector3(1, 0, 0), Vector3(1, 0, 0),
		# Left
		Vector3(-1, 0, 0), Vector3(-1, 0, 0), Vector3(-1, 0, 0), Vector3(-1, 0, 0),
	])

	# Define indices for triangles (2 triangles per face, 6 faces)
	var indices := PackedInt32Array([
		0, 3, 2,  2, 1, 0,    # Front
		4, 7, 6,  6, 5, 4,    # Back
		8, 11, 10,  10, 9, 8,  # Top
		12, 15, 14,  14, 13, 12, # Bottom
		16, 19, 18,  18, 17, 16, # Right
		20, 23, 22,  22, 21, 20, # Left
	])

	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh


func vertices() -> Array[Vector3]:
	var vertices := VERTICES.duplicate()
	for i in range(vertices.size()):
		vertices[i] *= side_length / 2.0
	return vertices


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
