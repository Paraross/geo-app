extends Task

var radius: TaskFloatValue = TaskFloatValue.default()

@onready var sphere: Sphere = $Sphere

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Radius", radius]]


func correct_area() -> float:
	return sphere.area()


func correct_volume() -> float:
	return sphere.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	sphere.set_radius(radius.value)
