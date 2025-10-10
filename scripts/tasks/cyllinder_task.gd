extends Task

var radius: TaskFloatValue = TaskFloatValue.new(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
)
var height: TaskFloatValue = TaskFloatValue.default()

@onready var cyllinder: MeshInstance3D = $Cyllinder
@onready var cyllinder_mesh: CylinderMesh = cyllinder.mesh

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	return 2.0 * base_area() + side_area()


func correct_volume() -> float:
	return base_area() * height.value


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	radius.randomize_and_round()
	height.randomize_and_round()
	if cyllinder_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	cyllinder_mesh.top_radius = radius.value
	cyllinder_mesh.bottom_radius = radius.value
	cyllinder_mesh.height = height.value


func base_area() -> float:
	return PI * radius.value * radius.value


func side_area() -> float:
	return 2.0 * PI * radius.value * height.value
