extends Task

@export var radius: float = 0.5

@onready var sphere: MeshInstance3D = $Sphere
@onready var sphere_mesh: SphereMesh = sphere.mesh

func _ready() -> void:
	sphere_mesh.radius = radius
	sphere_mesh.height = 2.0 * radius


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Radius", radius]]


func correct_area() -> float:
	var result := 4.0 * PI * radius * radius
	return Global.truncate(result)


func correct_volume() -> float:
	var result := 4.0 / 3.0 * PI * radius * radius * radius
	return Global.truncate(result)


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value := randf_range(min_value, max_value) / 2.0
	radius = Global.truncate_round(rand_value)
