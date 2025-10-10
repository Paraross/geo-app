class_name TaskFloatValue
extends RefCounted

var min_value: float
var max_value: float
var value: float

static func default() -> TaskFloatValue:
	return TaskFloatValue.new(
		Settings.default_task_data_min_value,
		Settings.default_task_data_max_value,
	)


func _init(min_val: float, max_val: float, val: float = 0.0) -> void:
	min_value = min_val
	max_value = max_val
	value = val


func random_in_range() -> float:
	return randf_range(min_value, max_value)


func randomize_and_round() -> void:
	value = Global.round_task_data(random_in_range())
