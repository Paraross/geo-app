extends Task

var radius: TaskFloatValue = TaskFloatValue.default()

@onready var sphere: Sphere = $Sphere

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Radius", radius]]


func correct_area() -> float:
	return 4.0 * PI * radius.value * radius.value


func correct_volume() -> float:
	return 4.0 / 3.0 * PI * radius.value * radius.value * radius.value


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	sphere.set_radius(radius.value)
