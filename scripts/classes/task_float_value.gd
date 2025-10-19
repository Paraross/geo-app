class_name TaskFloatValue
extends RefCounted

var min_value: float
var max_value: float
var value: float

static func default() -> TaskFloatValue:
	var min_val := Settings.default_task_data_min_value
	var max_val := Settings.default_task_data_max_value
	return TaskFloatValue.new(
		min_val,
		max_val,
		(min_val + max_val) / 2.0,
	)


func _init(min_val: float, max_val: float, val: float = 0.0) -> void:
	min_value = min_val
	max_value = max_val
	value = val


func random_in_range() -> float:
	return randf_range(min_value, max_value)


func randomize_and_round() -> void:
	value = Global.round_task_data(random_in_range())
