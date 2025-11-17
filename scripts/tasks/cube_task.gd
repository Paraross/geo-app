extends Task

var side_length: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: cube.side_length = side_length.value)

@onready var cube: Cube = $Cube


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Side": side_length }


func correct_area() -> float:
	return cube.area()


func correct_volume() -> float:
	return cube.volume()


func area_tip() -> String:
	return "A cube's area is the sum of all its 6 side areas"


func volume_tip() -> String:
	return "A cube's volume is its side length cubed"
