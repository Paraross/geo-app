class_name IntSetting
extends Setting

var min_value: int
var max_value: int

var prefix: String
var suffix: String

func _init(val: int, min_val: int, max_val: int, prefix: String = "", suffix: String = "") -> void:
	min_value = min_val
	max_value = max_val
	self.prefix = prefix
	self.suffix = suffix
	super._init(val)


func set_value(val: Variant) -> void:
	super.set_value(cast_and_clamp(val))


func set_value_no_change(val: Variant) -> void:
	super.set_value_no_change(cast_and_clamp(val))


func cast_and_clamp(val: Variant) -> int:
	assert(val is int)
	var val_int: int = val
	return clampi(val_int, min_value, max_value)


func ui_element() -> Control:
	var spin_box := SpinBox.new()
	spin_box.min_value = min_value
	spin_box.max_value = max_value
	spin_box.value = value
	spin_box.prefix = prefix
	spin_box.suffix = suffix
	spin_box.value_changed.connect(func (val: float) -> void: set_value(int(val)))
	return spin_box
