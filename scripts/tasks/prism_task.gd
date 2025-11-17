extends Task

# x
var base_base: TaskFloatValue = TaskFloatValue.default() \
	.with_on_set(func () -> void: prism.base_base = base_base.value)
# y
var base_height: TaskFloatValue = TaskFloatValue.default() \
	.with_on_set(func () -> void: prism.base_height = base_height.value)
# z
var height: TaskFloatValue = TaskFloatValue.default() \
	.with_on_set(func () -> void: prism.height = height.value)

@onready var prism: Prism = $Prism

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base base": base_base,
		"Base height": base_height,
		"Height": height,
	}


func correct_area() -> float:
	return prism.area()


func correct_volume() -> float:
	return prism.volume()


func area_tip() -> String:
	return "<TODO>"


func volume_tip() -> String:
	return "<TODO>"
