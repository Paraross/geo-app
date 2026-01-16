class_name Setting
extends RefCounted

var category: String

var value: Variant
var original_value: Variant
var tooltip: String

var changed: bool


func _init(category: String, val: Variant, tooltip: String = "") -> void:
	self.category = category
	value = val
	original_value = val
	self.tooltip = tooltip
	changed = false


func set_value(val: Variant) -> void:
	value = val
	changed = value != original_value


func set_value_no_change(val: Variant) -> void:
	value = val


func set_original_value() -> void:
	original_value = value
	changed = false


func reset_to_original() -> void:
	set_value(original_value)


func ui_element() -> Control:
	var label := Label.new()
	label.text = "%s" % value
	return label
