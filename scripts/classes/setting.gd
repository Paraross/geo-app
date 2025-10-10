class_name Setting
extends RefCounted

var value: Variant
var original_value: Variant
var changed: bool

func _init(val: Variant) -> void:
	value = val
	original_value = val
	changed = false


func set_value(val: Variant) -> void:
	value = val
	changed = value != original_value


func set_value_no_change(val: Variant) -> void:
	value = val


func set_original_value() -> void:
	original_value = value
	changed = false
