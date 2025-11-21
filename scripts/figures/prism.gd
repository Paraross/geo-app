class_name Prism
extends Figure

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
	get:
		return prism_mesh.size.x
	set(value):
		prism_mesh.size.x = value
		properties_changed.emit()

var base_height: float:
	get:
		return prism_mesh.size.y
	set(value):
		prism_mesh.size.y = value
		properties_changed.emit()

var height: float:
	get:
		return prism_mesh.size.z
	set(value):
		prism_mesh.size.z = value
		properties_changed.emit()

@onready var prism_mesh: PrismMesh = mesh


func vertices() -> Array[Vector3]:
	return VERTICES


func scaled_vertices() -> Array[Vector3]:
	var scaled_vertices := VERTICES.duplicate()
	for i in range(scaled_vertices.size()):
		scaled_vertices[i] *= prism_mesh.size / 2.0
	return scaled_vertices


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
