class_name SettingsScreen
extends Screen

@onready var settings_grid: GridContainer = $CenterContainer/PanelContainer/VBoxContainer/Grid

func on_entered() -> void:
	for setting_name in Settings.settings:
		Settings.settings[setting_name].set_original_value()

	fill_settings_grid()


func on_left() -> void:
	var is_changed := func (setting: Setting) -> bool: return setting.changed
	var settings_changed := Settings.settings.values().any(is_changed)

	if settings_changed:
		Settings.save_settings_to_file()


func fill_settings_grid() -> void:
	Global.clear_grid(settings_grid)
	for setting_name in Settings.settings:
		var setting := Settings.settings[setting_name]

		var label := Label.new()
		label.text = setting_name.capitalize()
		settings_grid.add_child(label)

		settings_grid.add_child(setting.ui_element())
