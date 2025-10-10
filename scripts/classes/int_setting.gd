class_name IntSetting
extends Setting

var min_value: int
var max_value: int

func _init(val: int, min_val: int, max_val: int) -> void:
	min_value = min_val
	max_value = max_val
	super._init(val)


func set_value(val: Variant) -> void:
	super.set_value(cast_and_clamp(val))


func set_value_no_change(val: Variant) -> void:
	super.set_value_no_change(cast_and_clamp(val))


func cast_and_clamp(val: Variant) -> int:
	assert(val is int)
	var val_int: int = val
	return clampi(val_int, min_value, max_value)
