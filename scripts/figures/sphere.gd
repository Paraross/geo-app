class_name Sphere
extends Figure

@onready var sphere_mesh: SphereMesh = mesh

func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func set_radius(radius: float) -> void:
	sphere_mesh.radius = radius
	sphere_mesh.height = 2.0 * radius
	properties_changed.emit()
