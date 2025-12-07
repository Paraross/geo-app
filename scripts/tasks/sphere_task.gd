extends Task

var radius: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: sphere.radius = radius.value)

@onready var sphere: Sphere = $Sphere


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Radius": radius }


func correct_area() -> float:
	return sphere.area()


func correct_volume() -> float:
	return sphere.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""
