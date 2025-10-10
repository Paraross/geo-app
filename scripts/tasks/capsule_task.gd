extends Task

var radius: TaskFloatValue = TaskFloatValue.new(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
)
var height: TaskFloatValue = TaskFloatValue.default()

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
	var sphere_area := 4.0 * PI * radius.value * radius.value
	var cyllinder_area := 2.0 * PI * radius.value * cyllinder_height()
	return sphere_area + cyllinder_area


func correct_volume() -> float:
	var sphere_volume := 4.0 / 3.0 * PI * radius.value * radius.value * radius.value
	var cyllinder_volume := PI * radius.value * radius.value * cyllinder_height()
	return sphere_volume + cyllinder_volume


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	height.randomize_and_round()
	if capsule_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	capsule_mesh.radius = radius.value
	capsule_mesh.height = height.value


func cyllinder_height() -> float:
	return height.value - 2.0 * radius.value
