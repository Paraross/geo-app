extends Task

var radius: TaskFloatValue = TaskFloatValue.with_min_max(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
).with_on_set(func() -> void: capsule.radius = radius.value)
var height: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: capsule.height = height.value)

@onready var capsule: Capsule = $Capsule


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.HARD


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Radius": radius,
		"Height": height,
	}


func correct_area() -> float:
	return capsule.area()


func correct_volume() -> float:
	return capsule.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""
