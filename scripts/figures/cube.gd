class_name Cube
extends Figure

const VERTICES: Array[Vector3] = [
	Vector3(-1, -1, -1),
	Vector3(-1, -1, 1),
	Vector3(-1, 1, -1),
	Vector3(-1, 1, 1),
	Vector3(1, -1, -1),
	Vector3(1, -1, 1),
	Vector3(1, 1, -1),
	Vector3(1, 1, 1),
]

var side_length: float:
	get:
		return cube_mesh.size.x
	set(value):
		cube_mesh.size.x = value
		cube_mesh.size.y = value
		cube_mesh.size.z = value
		properties_changed.emit()

@onready var cube_mesh: BoxMesh = mesh

func vertices() -> Array[Vector3]:
	return VERTICES


func scaled_vertices() -> Array[Vector3]:
	var scaled_vertices := VERTICES.duplicate()
	for i in range(scaled_vertices.size()):
		scaled_vertices[i] *= side_length / 2.0
	return scaled_vertices


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length


func set_side_length(side_length: float) -> void:
	cube_mesh.size.x = side_length
	cube_mesh.size.y = side_length
	cube_mesh.size.z = side_length
	properties_changed.emit()
