class_name Cyllinder
extends Figure

@onready var cyllinder_mesh: CylinderMesh = mesh


func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func area() -> float:
	return 2.0 * base_area() + side_area()


func volume() -> float:
	return base_area() * height()


func radius() -> float:
	return cyllinder_mesh.top_radius


func height() -> float:
	return cyllinder_mesh.height


func base_area() -> float:
	return PI * radius() * radius()


func side_area() -> float:
	return 2.0 * PI * radius() * height()


func set_properties(radius: float, height: float) -> void:
	cyllinder_mesh.top_radius = radius
	cyllinder_mesh.bottom_radius = radius
	cyllinder_mesh.height = height
	properties_changed.emit()
