class_name Prism
extends Figure

const VERTICES: Array[Vector3] = [
	# front
	Vector3(-1, -1, 1), # left
	Vector3(1, -1, 1), # right
	Vector3(0, 1, 1), # top
	# back
	Vector3(-1, -1, -1),
	Vector3(1, -1, -1),
	Vector3(0, 1, -1),
]

@onready var prism_mesh: PrismMesh = mesh

func vertices() -> Array[Vector3]:
	return VERTICES


func scaled_vertices() -> Array[Vector3]:
	var scaled_vertices := VERTICES.duplicate()
	for i in range(scaled_vertices.size()):
		scaled_vertices[i] *= prism_mesh.size / 2.0
	return scaled_vertices


func set_properties(base_base: float, base_height: float, height: float) -> void:
	prism_mesh.size.x = base_base
	prism_mesh.size.y = base_height
	prism_mesh.size.z = height
	properties_changed.emit()
