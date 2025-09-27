extends Task

@export var radius: float = 0.5
@export var height: float = 1.0

@onready var cyllinder: MeshInstance3D = $Cyllinder
@onready var cyllinder_mesh: CylinderMesh = cyllinder.mesh

func _ready() -> void:
	cyllinder_mesh.top_radius = radius
	cyllinder_mesh.bottom_radius = radius
	cyllinder_mesh.height = height


func values() -> Array[Array]:
	return [
		["Radius", radius],
		["Height", height],
	]


func correct_area() -> float:
	var result := 2.0 * base_area() + side_area()
	return truncate(result)


func correct_volume() -> float:
	var result := base_area() * height
	return truncate(result)


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	var rand_value1 := randf_range(min_value, max_value) / 2.0
	var rand_value2 := randf_range(min_value, max_value)
	radius = truncate_round(rand_value1)
	height = truncate_round(rand_value2)


func base_area() -> float:
	return PI * radius * radius


func side_area() -> float:
	return 2.0 * PI * radius * height
