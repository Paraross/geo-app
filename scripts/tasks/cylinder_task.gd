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


func area_tip() -> String:
	return "A cylinder's total area is 2 × base area + side area"


func volume_tip() -> String:
	return "A cylinder's volume is base area × height"


func steps() -> Array[Step]:
	return [
		Step.new(
			"1. Calculate base area",
			"A circle's area is π × radius²",
			cylinder.base_area,
		),
		Step.new(
			"2. Calculate total area",
			"A cylinder's total area is 2 × base area + side area",
			cylinder.area,
		),
		Step.new(
			"3. Calculate volume",
			"A cylinder's volume is base area × height",
			cylinder.volume,
		),
	]
