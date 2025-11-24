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

@onready var shape: BoxShape3D = ($Area3D/CollisionShape3D as CollisionShape3D).shape

var side_length: float:
	get:
		return cube_mesh.size.x
	set(value):
		var vec := Vector3(value, value, value)
		cube_mesh.size = vec
		shape.size = vec
		properties_changed.emit()

@onready var cube_mesh: BoxMesh = mesh


func vertices() -> Array[Vector3]:
	return VERTICES


func scaled_vertices() -> Array[Vector3]:
	var scaled_vertices := VERTICES.duplicate()
	for i in range(scaled_vertices.size()):
		scaled_vertices[i] *= side_length / 2.0
	return scaled_vertices


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
