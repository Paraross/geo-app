@abstract class_name Task
extends Node3D

@export var min_value: float = 1.0
@export var max_value: float = 2.0

@abstract func difficulty() -> Global.TaskDifficulty


@abstract func values() -> Array[Array]


@abstract func correct_area() -> float


@abstract func correct_volume() -> float


@abstract func area_tip() -> String


@abstract func volume_tip() -> String


@abstract func randomize_values() -> void


func truncate(x: float) -> float:
	return float(roundf(100.0 * x)) / 100.0


func truncate_round(x: float) -> float:
	var truncated := truncate(x)
	return roundf(10.0 * truncated) / 10.0
