extends Task

var side_length: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: cube.side_length = side_length.value)

@onready var cube: Cube = $Cube


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Side": side_length }


func area_tip() -> String:
	return "A cube's area is the sum of all its 6 side areas"


func volume_tip() -> String:
	return "A cube's volume is its side length cubed"


func steps() -> Array[Step]:
	return [
		Step.new(
			"1. Calculate face area",
			"A cube face is a square, so its area is side × side",
			func() -> float: return cube.side_length * cube.side_length
		),
		Step.new(
			"2. Calculate total area",
			"A cube's total area is the sum of all its 6 face areas",
			func() -> float: return cube.area()
		),
		Step.new(
			"3. Calculate volume",
			"A cube's total area is the sum of all its 6 face areas",
			func() -> float: return cube.volume()
		),
	]
