class_name Capsule
extends Figure

@onready var capsule_mesh: CapsuleMesh = mesh

func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func set_properties(radius: float, height: float) -> void:
	capsule_mesh.radius = radius
	capsule_mesh.height = height
	properties_changed.emit()
