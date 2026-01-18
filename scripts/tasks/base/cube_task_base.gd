@abstract class_name CubeTaskBase
extends Task

@onready var cube: Cube = $Cube


@abstract func difficulty() -> Global.TaskDifficulty


@abstract func values() -> Dictionary[String, TaskFloatValue]


func description() -> String:
	return """A cube is given.
The length of the cube's side is [b]{Side}[/b].
"""


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate face area",
			"A cube face is a square, so its area is side × side",
			0,
			cube.face_area,
		),
		Step.new(
			"Calculate total area",
			"A cube's total area is the sum of all its 6 face areas",
			0,
			cube.area,
		),
		Step.new(
			"Calculate volume",
			"A cube's volume is the area of one face multiplied by its side length",
			0,
			cube.volume,
		),
	]
