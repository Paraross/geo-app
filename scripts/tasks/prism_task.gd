extends Task

# x
@export var base_base: float = 1.0
# y
@export var base_height: float = 1.0
# z
@export var height: float = 1.0

@onready var prism: MeshInstance3D = $Prism
@onready var prism_mesh: PrismMesh = prism.mesh

func _ready() -> void:
	prism_mesh.size.x = base_base
	prism_mesh.size.y = base_height
	prism_mesh.size.z = height


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
	var bottom_side_area := base_base * height
	var side_side_area := sqrt(pow(base_base / 2.0, 2.0) + pow(base_height, 2.0))
	return 2.0 * (base_area() + side_side_area) + bottom_side_area


func correct_volume() -> float:
	return base_area() * height


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value1 := randf_range(min_value, max_value)
	var rand_value2 := randf_range(min_value, max_value)
	var rand_value3 := randf_range(min_value, max_value)

	base_base = Global.round_with_digits(rand_value1, 1)
	base_height = Global.round_with_digits(rand_value2, 1)
	height = Global.round_with_digits(rand_value3, 1)


func base_area() -> float:
	return base_base * base_height / 2.0
