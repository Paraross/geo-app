class_name TaskFloatValue
extends RefCounted

var min_value: float
var max_value: float
var value: float:
	set(new_value):
		value = new_value
		if not on_set.is_null():
			on_set.call()
var precision_digits: int = 0
var on_set: Callable


static func with_min_max(min_val: float, max_val: float, precision_digits: int = 0) -> TaskFloatValue:
	return TaskFloatValue.new(min_val, max_val, (min_val + max_val) / 2.0, precision_digits)


func _init(min_val: float, max_val: float, val: float, precision_digits: int) -> void:
	min_value = min_val
	max_value = max_val
	value = val
	self.precision_digits = precision_digits


func random_in_range() -> float:
	return randf_range(min_value, max_value)


func randomize_and_round() -> void:
	value = Global.round_with_digits(random_in_range(), precision_digits)


func with_on_set(on_set_function: Callable) -> TaskFloatValue:
	on_set = on_set_function
	return self
