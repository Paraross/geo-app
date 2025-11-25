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

@onready var sphere_mesh: SphereMesh = mesh_instance.mesh:
	get:
		return mesh_instance.mesh
	set(value):
		mesh_instance.mesh = value
@onready var shape: SphereShape3D = collision_shape.shape:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func vertices() -> Array[Vector3]:
	return []


func edges() -> Array[Edge]:
	return []


func area() -> float:
	return 4.0 * PI * radius * radius


func volume() -> float:
	return 4.0 / 3.0 * PI * radius * radius * radius
