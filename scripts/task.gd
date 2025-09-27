class_name Task
extends Node3D

@export var min_value: float = 1.0
@export var max_value: float = 2.0

func values() -> Array[Array]:
	return []


func correct_area() -> float:
	return NAN


func correct_volume() -> float:
	return NAN


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func randomize_values() -> void:
	pass


func truncate(x: float) -> float:
	return float(roundf(100.0 * x)) / 100.0


func truncate_round(x: float) -> float:
	var truncated := truncate(x)
	return roundf(10.0 * truncated) / 10.0
