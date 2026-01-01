class_name Cylinder
extends Figure

var radius: float:
	get:
		return cylinder_mesh.top_radius
	set(value):
		cylinder_mesh.top_radius = value
		cylinder_mesh.bottom_radius = value
		shape.radius = value
		change_properties()

var height: float:
	get:
		return cylinder_mesh.height
	set(value):
		cylinder_mesh.height = value
		shape.height = value
		change_properties()

@onready var cylinder_mesh: CylinderMesh:
	get:
		return mesh_instance.mesh
	set(value):
		mesh_instance.mesh = value
@onready var shape: CylinderShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func area() -> float:
	return 2.0 * base_area() + side_area()


func volume() -> float:
	return base_area() * height


func base_area() -> float:
	return PI * radius * radius


func side_area() -> float:
	return 2.0 * PI * radius * height
