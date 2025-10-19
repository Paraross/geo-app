extends Task

var radius: TaskFloatValue = TaskFloatValue.new(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
)
var height: TaskFloatValue = TaskFloatValue.default()

@onready var capsule: Capsule = $Capsule

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.HARD


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	return capsule.area()


func correct_volume() -> float:
	return capsule.volume()


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	height.randomize_and_round()
	set_mesh_properties()


func set_mesh_properties() -> void:
	capsule.set_properties(radius.value, height.value)
