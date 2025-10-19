class_name Sphere
extends Figure

@onready var sphere_mesh: SphereMesh = mesh

func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func area() -> float:
	return 4.0 * PI * radius() * radius()


func volume() -> float:
	return 4.0 / 3.0 * PI * radius() * radius() * radius()


func radius() -> float:
	return sphere_mesh.radius


func set_radius(radius: float) -> void:
	sphere_mesh.radius = radius
	sphere_mesh.height = 2.0 * radius
	properties_changed.emit()
