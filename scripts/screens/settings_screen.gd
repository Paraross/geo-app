class_name SettingsScreen
extends Screen

var settings: Dictionary[String, Setting] = {
	"data_precision": Setting.new(),
	"answer_precision": Setting.new(),
}

@onready var settings_container: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer
@onready var data_precision_spin_box: SpinBox = settings_container.get_node("DataPrecision/SpinBox")
@onready var answer_precision_spin_box: SpinBox = settings_container.get_node("AnswerPrecision/SpinBox")

func on_entered() -> void:
	for setting_name in settings:
		settings[setting_name].set_original_value(Settings.settings[setting_name])

	data_precision_spin_box.value = settings["data_precision"].original_value
	answer_precision_spin_box.value = settings["answer_precision"].original_value


func on_left() -> void:
	var settings_changed := settings.values().any(func (setting: Setting) -> bool: return setting.changed)

	if settings_changed:
		Settings.save_settings_to_file()


func _on_data_precision_changed(value: float) -> void:
	settings["data_precision"].set_value(int(value))
	Settings.settings["data_precision"] = int(value)


func _on_answer_precision_changed(value: float) -> void:
	settings["answer_precision"].set_value(int(value))
	Settings.settings["answer_precision"] = int(value)


class Setting:
	var original_value: Variant
	var changed: bool

	func set_value(value: Variant) -> void:
		changed = value != original_value


	func set_original_value(value: Variant) -> void:
		original_value = value
		changed = false
