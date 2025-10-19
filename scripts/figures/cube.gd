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

@onready var cube_mesh: BoxMesh = mesh

func vertices() -> Array[Vector3]:
	return VERTICES


func scaled_vertices() -> Array[Vector3]:
	var scaled_vertices := VERTICES.duplicate()
	for i in range(scaled_vertices.size()):
		scaled_vertices[i] *= cube_mesh.size.x / 2.0
	return scaled_vertices


func set_side_length(side_length: float) -> void:
	cube_mesh.size.x = side_length
	cube_mesh.size.y = side_length
	cube_mesh.size.z = side_length
	properties_changed.emit()
