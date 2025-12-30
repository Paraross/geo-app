extends Task

var side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
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
