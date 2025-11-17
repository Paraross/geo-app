class_name TaskFloatValue
extends RefCounted

var min_value: float
var max_value: float
var value: float:
	set(new_value):
		value = new_value
		if not on_set.is_null():
			on_set.call()
var on_set: Callable

static func with_min_max(min_val: float, max_val: float) -> TaskFloatValue:
	return TaskFloatValue.new(min_val, max_val, (min_val + max_val) / 2.0)


static func default() -> TaskFloatValue:
	var min_val := Settings.default_task_data_min_value
	var max_val := Settings.default_task_data_max_value
	return TaskFloatValue.with_min_max(min_val, max_val)


func _init(min_val: float, max_val: float, val: float) -> void:
	min_value = min_val
	max_value = max_val
	value = val


func random_in_range() -> float:
	return randf_range(min_value, max_value)


func randomize_and_round() -> void:
	value = Global.round_task_data(random_in_range())


func with_on_set(on_set_function: Callable) -> TaskFloatValue:
	on_set = on_set_function
	return self
