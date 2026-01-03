class_name HexagonalPyramidTask
extends Task

var base_side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.base_side_length = base_side_length.value)
var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.height = height.value)

@onready var pyramid: HexPyramid = $HexPyramid


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func description() -> String:
	return """A pyramid is given. The pyramid has a hexagonal base.
The length of the base's side is [b]{Base side length}[/b].
The height of the pyramid is [b]{Height}[/b].
"""


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base side length": base_side_length,
		"Height": height,
	}


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
