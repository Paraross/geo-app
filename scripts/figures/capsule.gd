class_name Capsule
extends Figure

var radius: float:
	get:
		return capsule_mesh.radius
	set(value):
		capsule_mesh.radius = value
		shape.radius = value
		properties_changed.emit()

var height: float:
	get:
		return capsule_mesh.height
	set(value):
		capsule_mesh.height = value
		shape.height = value
		properties_changed.emit()

@onready var capsule_mesh: CapsuleMesh:
	get:
		return mesh_instance.mesh
	set(value):
		mesh_instance.mesh = value
@onready var shape: CapsuleShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func vertices() -> Array[Vector3]:
	return []


func edges() -> Array[Edge]:
	return []


func area() -> float:
	var sphere_area := 4.0 * PI * radius * radius
	var capsule_area := 2.0 * PI * radius * capsule_height()
	return sphere_area + capsule_area


func volume() -> float:
	var sphere_volume := 4.0 / 3.0 * PI * radius * radius * radius
	var capsule_volume := PI * radius * radius * capsule_height()
	return sphere_volume + capsule_volume


func capsule_height() -> float:
	return height - 2.0 * radius


func set_properties(radius: float, height: float) -> void:
	capsule_mesh.radius = radius
	capsule_mesh.height = height
	properties_changed.emit()
