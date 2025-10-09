class_name SettingsScreen
extends Screen

var data_precision: Setting = Setting.new()
var answer_precision: Setting = Setting.new()

@onready var settings_container: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer
@onready var data_precision_spin_box: SpinBox = settings_container.get_node("DataPrecision/SpinBox")
@onready var answer_precision_spin_box: SpinBox = settings_container.get_node("AnswerPrecision/SpinBox")

func on_entered() -> void:
	data_precision.set_original_value(Settings.data_precision)
	answer_precision.set_original_value(Settings.answer_precision)
	data_precision_spin_box.value = data_precision.original_value
	answer_precision_spin_box.value = answer_precision.original_value


func on_left() -> void:
	var all_settings := [
		data_precision,
		answer_precision,
	]

	var settings_changed := all_settings.any(func (setting: Setting) -> bool: return setting.changed)

	if settings_changed:
		Settings.save_settings_to_file()


func _on_data_precision_changed(value: float) -> void:
	data_precision.set_value(int(value))
	Settings.data_precision = int(value)


func _on_answer_precision_changed(value: float) -> void:
	answer_precision.set_value(int(value))
	Settings.answer_precision = int(value)


class Setting:
	var original_value: Variant
	var changed: bool

	func set_value(value: Variant) -> void:
		changed = value != original_value


	func set_original_value(value: Variant) -> void:
		original_value = value
		changed = false
