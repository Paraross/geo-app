extends Task

# x
var base_base: TaskFloatValue = TaskFloatValue.default()
# y
var base_height: TaskFloatValue = TaskFloatValue.default()
# z
var height: TaskFloatValue = TaskFloatValue.default()

@onready var prism: MeshInstance3D = $Prism
@onready var prism_mesh: PrismMesh = prism.mesh

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [
		["Base base", base_base],
		["Base height", base_height],
		["Height", height],
	]


# correct only for a isosceles triangle
func correct_area() -> float:
	var bottom_side_area := base_base.value * height.value
	var side_side_area := sqrt(pow(base_base.value / 2.0, 2.0) + pow(base_height.value, 2.0))
	return 2.0 * (base_area() + side_side_area) + bottom_side_area


func correct_volume() -> float:
	return base_area() * height.value


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	base_base.randomize_and_round()
	base_height.randomize_and_round()
	height.randomize_and_round()
	if prism_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	prism_mesh.size.x = base_base.value
	prism_mesh.size.y = base_height.value
	prism_mesh.size.z = height.value


func base_area() -> float:
	return base_base.value * base_height.value / 2.0
