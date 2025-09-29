extends Task

@export var radius: float = 0.5
@export var height: float = 1.0

@onready var cyllinder: MeshInstance3D = $Cyllinder
@onready var cyllinder_mesh: CylinderMesh = cyllinder.mesh

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	return 2.0 * base_area() + side_area()


func correct_volume() -> float:
	return base_area() * height


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value1 := randf_range(min_value, max_value) / 2.0
	var rand_value2 := randf_range(min_value, max_value)
	radius = Global.round_task_data(rand_value1)
	height = Global.round_task_data(rand_value2)
	if cyllinder_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	cyllinder_mesh.top_radius = radius
	cyllinder_mesh.bottom_radius = radius
	cyllinder_mesh.height = height


func base_area() -> float:
	return PI * radius * radius


func side_area() -> float:
	return 2.0 * PI * radius * height
