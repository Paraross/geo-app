extends Task

var side_length: TaskFloatValue = TaskFloatValue.default()

@onready var cube: MeshInstance3D = $Cube
@onready var cube_mesh: BoxMesh = cube.mesh


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Array[Array]:
	return [["Side", side_length]]


func correct_area() -> float:
	return 6.0 * side_length.value * side_length.value


func correct_volume() -> float:
	return side_length.value * side_length.value * side_length.value


func area_tip() -> String:
	return "A cube's area is the sum of all its 6 side areas"


func volume_tip() -> String:
	return "A cube's volume is its side length cubed"


func randomize_values() -> void:
	side_length.randomize_and_round()
	if cube_mesh != null:
		set_mesh_properties()


func set_mesh_properties() -> void:
	cube_mesh.size.x = side_length.value
	cube_mesh.size.y = side_length.value
	cube_mesh.size.z = side_length.value
