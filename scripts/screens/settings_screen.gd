class_name SettingsScreen
extends Screen

@onready var settings_container: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer
@onready var data_precision_spin_box: SpinBox = settings_container.get_node("DataPrecision/SpinBox")
@onready var answer_precision_spin_box: SpinBox = settings_container.get_node("AnswerPrecision/SpinBox")

func on_entered() -> void:
	for setting_name in Settings.settings:
		Settings.settings[setting_name].set_original_value()

	data_precision_spin_box.value = Settings.data_precision
	answer_precision_spin_box.value = Settings.answer_precision


func on_left() -> void:
	var is_changed := func (setting: Setting) -> bool: return setting.changed
	var settings_changed := Settings.settings.values().any(is_changed)

	if settings_changed:
		Settings.save_settings_to_file()


func _on_data_precision_changed(value: float) -> void:
	Settings.data_precision = int(value)


func _on_answer_precision_changed(value: float) -> void:
	Settings.answer_precision = int(value)
