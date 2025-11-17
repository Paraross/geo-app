@abstract class_name Task
extends Node3D

func _ready() -> void:
	var values := values()
	for value_name in values:
		values[value_name].on_set.call()


@abstract func difficulty() -> Global.TaskDifficulty

@abstract func values() -> Dictionary[String, TaskFloatValue]

@abstract func correct_area() -> float

@abstract func correct_volume() -> float

@abstract func area_tip() -> String

@abstract func volume_tip() -> String

func randomize_values() -> void:
	var values := values()
	for value_name in values:
		values[value_name].randomize_and_round()
