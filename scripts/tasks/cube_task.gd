extends Task

var side_length: TaskFloatValue = TaskFloatValue.default()

@onready var cube: Cube = $Cube

func _ready() -> void:
	side_length.on_set = func () -> void: cube.set_side_length(side_length.value)
	super._ready()


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Side", side_length]]


func correct_area() -> float:
	return cube.area()


func correct_volume() -> float:
	return cube.volume()


func area_tip() -> String:
	return "A cube's area is the sum of all its 6 side areas"


func volume_tip() -> String:
	return "A cube's volume is its side length cubed"


func randomize_values() -> void:
	side_length.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	cube.set_side_length(side_length.value)
