class_name FloatSetting
extends Setting

var min_value: float
var max_value: float
var step: float

var suffix: String


func _init(category1: String, val: float, min_val: float, max_val: float, step: float, suffix: String = "", tooltip1: String = "") -> void:
	min_value = min_val
	max_value = max_val
	self.step = step
	self.suffix = suffix
	super._init(category1, val, tooltip1)


func set_value(val: Variant) -> void:
	super.set_value(cast_and_clamp(val))


func set_value_no_change(val: Variant) -> void:
	super.set_value_no_change(cast_and_clamp(val))


func cast_and_clamp(val: Variant) -> float:
	assert(val is float)
	var val_float: float = val
	return clampf(val_float, min_value, max_value)


func ui_element() -> Control:
	var spin_box := SpinBox.new()
	spin_box.min_value = min_value
	spin_box.max_value = max_value
	spin_box.step = step
	spin_box.value = value
	spin_box.suffix = suffix
	spin_box.value_changed.connect(func(val: float) -> void: set_value(val))
	spin_box.tooltip_text = tooltip
	return spin_box
