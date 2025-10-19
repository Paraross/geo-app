extends Task

# x
var base_base: TaskFloatValue = TaskFloatValue.default()
# y
var base_height: TaskFloatValue = TaskFloatValue.default()
# z
var height: TaskFloatValue = TaskFloatValue.default()

@onready var prism: Prism = $Prism

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [
		["Base base", base_base],
		["Base height", base_height],
		["Height", height],
	]


func correct_area() -> float:
	return prism.area()


func correct_volume() -> float:
	return prism.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	base_base.randomize_and_round()
	base_height.randomize_and_round()
	height.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	prism.set_properties(base_base.value, base_height.value, height.value)

