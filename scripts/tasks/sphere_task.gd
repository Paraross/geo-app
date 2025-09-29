extends Task

@export var radius: float = 0.5

@onready var sphere: MeshInstance3D = $Sphere
@onready var sphere_mesh: SphereMesh = sphere.mesh

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Radius", radius]]


func correct_area() -> float:
	return 4.0 * PI * radius * radius


func correct_volume() -> float:
	return 4.0 / 3.0 * PI * radius * radius * radius


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value := randf_range(min_value, max_value) / 2.0
	radius = Global.round_with_digits(rand_value, 1)
	if sphere_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	sphere_mesh.radius = radius
	sphere_mesh.height = 2.0 * radius
