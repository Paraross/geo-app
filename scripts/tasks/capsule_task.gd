extends Task

@export var radius: float = 0.5
@export var height: float = 1.0

@onready var capsule: MeshInstance3D = $Capsule
@onready var capsule_mesh: CapsuleMesh = capsule.mesh

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.HARD


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	var sphere_area := 4.0 * PI * radius * radius
	var cyllinder_area := 2.0 * PI * radius * cyllinder_height()
	return sphere_area + cyllinder_area


func correct_volume() -> float:
	var sphere_volume := 4.0 / 3.0 * PI * radius * radius * radius
	var cyllinder_volume := PI * radius * radius * cyllinder_height()
	return sphere_volume + cyllinder_volume


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value1 := randf_range(min_value, max_value) / 2.0
	var rand_value2 := randf_range(min_value, max_value) * 2.0
	radius = Global.round_task_data(rand_value1)
	height = Global.round_task_data(rand_value2)
	if capsule_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	capsule_mesh.radius = radius
	capsule_mesh.height = height


func cyllinder_height() -> float:
	return height - 2.0 * radius
