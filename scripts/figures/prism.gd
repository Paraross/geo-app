class_name Prism
extends Polyhedron

const VERTICES: Array[Vector3] = [
	# front
	Vector3(-1, -1, 1), # left
	Vector3(1, -1, 1), # right
	Vector3(0, 1, 1), # top
	# back
	Vector3(-1, -1, -1), # left
	Vector3(1, -1, -1), # right
	Vector3(0, 1, -1), # top
]

var edges1: Array[Edge] = [
	# front
	Edge.new(0, 1),
	Edge.new(1, 2), #
	Edge.new(2, 0), #
	# back
	Edge.new(3, 4),
	Edge.new(4, 5),
	Edge.new(5, 3),
	# height
	Edge.new(0, 3),
	Edge.new(1, 4),
	Edge.new(2, 5),
]

var base_base: float:
	set(value):
		base_base = value
		set_mesh()
		update_collision_shape()
		properties_changed.emit()

var base_height: float:
	set(value):
		base_height = value
		set_mesh()
		update_collision_shape()
		properties_changed.emit()

var height: float:
	set(value):
		height = value
		set_mesh()
		update_collision_shape()
		properties_changed.emit()


func scaled(vertex: Vector3) -> Vector3:
	return vertex * Vector3(base_base, base_height, height) / 2.0


func normalized_vertices() -> Array[Vector3]:
	return VERTICES.duplicate()


func edges() -> Array[Edge]:
	return edges1


# correct only for a isosceles triangle
func area() -> float:
	var bottom_side_area := base_base * height
	var side_side_area := sqrt(pow(base_base / 2.0, 2.0) + pow(base_height, 2.0))
	return 2.0 * (base_area() + side_side_area) + bottom_side_area


func volume() -> float:
	return base_area() * height


func base_area() -> float:
	return base_base * base_height / 2.0
