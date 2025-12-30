class_name PyramidTask
extends Task

var base_side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.base_side_length = base_side_length.value)
var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.height = height.value)

@onready var pyramid: Pyramid = $Pyramid


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base side length": base_side_length,
		"Height": height,
	}


func area_tip() -> String:
	return "A prism's total area is base area + side triangles area"


func volume_tip() -> String:
	return "A prism's volume is base area × height ÷ 3"


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate base area",
			"A cube's area is side × side",
			0,
			pyramid.base_area,
		),
		Step.new(
			"Calculate volume",
			"A prism's volume is base area × height ÷ 3",
			1,
			pyramid.volume,
		),
	]
