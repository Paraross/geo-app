class_name CubeTask
extends Task

@export var side_length: float = 1.0

@onready var cube: MeshInstance3D = $Cube
@onready var cube_mesh: BoxMesh = cube.mesh

func _ready() -> void:
	cube_mesh.size.x = side_length
	cube_mesh.size.y = side_length
	cube_mesh.size.z = side_length


func values() -> Array[Array]:
	return [["Side", side_length]]


func correct_area() -> float:
	var result := 6.0 * side_length * side_length
	return truncate(result)


func correct_volume() -> float:
	var result := side_length * side_length * side_length
	return truncate(result)


func area_tip() -> String:
	return "A cube's area is the sum of all its 6 side areas"


func volume_tip() -> String:
	return "A cube's volume is its side length cubed"


func randomize_values() -> void:
	var rand_value := randf_range(0.5, 2.5)
	var truncated := truncate(rand_value)
	var rounded := roundf(10.0 * truncated) / 10.0
	side_length = rounded


func truncate(x: float) -> float:
	return float(int(100.0 * x)) / 100.0
