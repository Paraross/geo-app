@abstract class_name Task
extends Node3D

func _ready() -> void:
	set_mesh_properties()


func idk() -> Callable:
	return func (message: String) -> void: print("task message: %s" % message)


@abstract func difficulty() -> Global.TaskDifficulty

@abstract func values() -> Array[Array]

@abstract func correct_area() -> float

@abstract func correct_volume() -> float

@abstract func area_tip() -> String

@abstract func volume_tip() -> String

@abstract func randomize_values() -> void

@abstract func set_mesh_properties() -> void
