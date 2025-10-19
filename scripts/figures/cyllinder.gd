class_name Cyllinder
extends Figure

@onready var cyllinder_mesh: CylinderMesh = mesh

func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func set_properties(radius: float, height: float) -> void:
	cyllinder_mesh.top_radius = radius
	cyllinder_mesh.bottom_radius = radius
	cyllinder_mesh.height = height
	properties_changed.emit()
