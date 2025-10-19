class_name Capsule
extends Figure

@onready var capsule_mesh: CapsuleMesh = mesh

func vertices() -> Array[Vector3]:
	return []


func scaled_vertices() -> Array[Vector3]:
	return []


func area() -> float:
	var sphere_area := 4.0 * PI * radius() * radius()
	var cyllinder_area := 2.0 * PI * radius() * cyllinder_height()
	return sphere_area + cyllinder_area


func volume() -> float:
	var sphere_volume := 4.0 / 3.0 * PI * radius() * radius() * radius()
	var cyllinder_volume := PI * radius() * radius() * cyllinder_height()
	return sphere_volume + cyllinder_volume


func radius() -> float:
	return capsule_mesh.radius


func height() -> float:
	return capsule_mesh.height


func cyllinder_height() -> float:
	return height() - 2.0 * radius()


func set_properties(radius: float, height: float) -> void:
	capsule_mesh.radius = radius
	capsule_mesh.height = height
	properties_changed.emit()
