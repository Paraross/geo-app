extends Task

@export var radius: float = 0.5
@export var height: float = 1.0

@onready var capsule: MeshInstance3D = $Capsule
@onready var capsule_mesh: CapsuleMesh = capsule.mesh

func _ready() -> void:
	capsule_mesh.radius = radius
	capsule_mesh.height = height


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	var sphere_area := 4.0 * PI * radius * radius
	var cyllinder_area := 2.0 * PI * radius * cyllinder_height()
	var result := sphere_area + cyllinder_area
	return Global.truncate(result)


func correct_volume() -> float:
	var sphere_volume := 4.0 / 3.0 * PI * radius * radius * radius
	var cyllinder_volume := PI * radius * radius * cyllinder_height()
	var result := sphere_volume + cyllinder_volume
	return Global.truncate(result)


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value1 := randf_range(min_value, max_value) / 2.0
	var rand_value2 := randf_range(min_value, max_value) * 2.0
	radius = Global.truncate_round(rand_value1)
	height = Global.truncate_round(rand_value2)


func cyllinder_height() -> float:
	return height - 2.0 * radius
