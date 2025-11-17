extends Task

var radius: TaskFloatValue = TaskFloatValue.with_min_max(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
)
var height: TaskFloatValue = TaskFloatValue.default()

@onready var cyllinder: Cyllinder = $Cyllinder


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	return cyllinder.area()


func correct_volume() -> float:
	return cyllinder.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	height.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	cyllinder.set_properties(radius.value, height.value)
