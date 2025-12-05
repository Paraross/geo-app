class_name Cube
extends Polyhedron

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


func scaled(vertex: Vector3) -> Vector3:
	return vertex * side_length / 2.0


func normalized_vertices() -> Array[Vector3]:
	return VERTICES.duplicate()


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
