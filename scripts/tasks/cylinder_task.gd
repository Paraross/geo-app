extends Task

var radius: TaskFloatValue = TaskFloatValue.with_min_max(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
).with_on_set(func() -> void: cylinder.radius = radius.value)
var height: TaskFloatValue = TaskFloatValue.default().with_on_set(func() -> void: cylinder.height = height.value)

@onready var cylinder: Cylinder = $Cylinder


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Radius": radius,
		"Height": height,
	}


func correct_area() -> float:
	return cylinder.area()


func correct_volume() -> float:
	return cylinder.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


# func randomize_values() -> void:
# 	radius.randomize_and_round()
# 	height.randomize_and_round()
