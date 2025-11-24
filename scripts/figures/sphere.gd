class_name Sphere
extends Figure

var radius: float:
	get:
		return sphere_mesh.radius
	set(value):
		sphere_mesh.radius = value
		sphere_mesh.height = 2.0 * value
		shape.radius = value
		properties_changed.emit()

@onready var sphere_mesh: SphereMesh = mesh
@onready var shape: SphereShape3D = ($Area3D/CollisionShape3D as CollisionShape3D).shape


func vertices() -> Array[Vector3]:
	return []


func edges() -> Array[Edge]:
	return []


func area() -> float:
	return 4.0 * PI * radius * radius


func volume() -> float:
	return 4.0 / 3.0 * PI * radius * radius * radius
