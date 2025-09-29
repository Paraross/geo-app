@abstract class_name Task
extends Node3D

@export var min_value: float = 1.0
@export var max_value: float = 2.0

func _ready() -> void:
	set_mesh_properties()

@abstract func difficulty() -> Global.TaskDifficulty

@abstract func values() -> Array[Array]

@abstract func correct_area() -> float

@abstract func correct_volume() -> float

@abstract func area_tip() -> String

@abstract func volume_tip() -> String

@abstract func randomize_values() -> void

@abstract func set_mesh_properties() -> void
