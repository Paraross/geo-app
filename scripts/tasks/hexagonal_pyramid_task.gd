class_name HexagonalPyramidTask
extends Task

var base_side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.base_side_length = base_side_length.value)
var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: pyramid.height = height.value)

@onready var pyramid: HexPyramid = $HexPyramid


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.HARD


func description() -> String:
	return """A pyramid is given. The base of the pyramid is a regular hexagon.
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
			"Calculate area of one triangle of the hexagonal base",
			"Each triangle of a regular hexagon is an equilateral triangle",
			1,
			pyramid.base_triangle_area,
		),
		Step.new(
			"Calculate base area",
			"The hexagonal base consists of 6 triangles",
			1,
			pyramid.base_area,
		),
		Step.new(
			"Calculate volume",
			"A pyramid's volume is base area * height / 3",
			1,
			pyramid.volume,
		),
	]
