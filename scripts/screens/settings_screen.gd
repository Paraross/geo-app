class_name SettingsScreen
extends Screen

@onready var settings_container: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer/SettingsContainer


func on_entered() -> void:
	Settings.set_all_original_values()
	fill_settings_grid()


func on_left() -> void:
	if did_settings_change():
		Settings.save_settings_to_file()


func fill_settings_grid() -> void:
	for child in settings_container.get_children():
		child.queue_free()

	var category_containers: Dictionary[String, Container] = { }

	for setting_name in Settings.settings:
		var setting := Settings.settings[setting_name]
		var category_container: Container = category_containers.get(setting.category)

		if category_container == null:
			var category_label := Label.new()
			category_label.text = setting.category
			category_label.theme_type_variation = "BigLabel"
			settings_container.add_child(category_label)

			var new_category_container := GridContainer.new()
			new_category_container.columns = 2

			category_containers[setting.category] = new_category_container
			settings_container.add_child(new_category_container)
			category_container = new_category_container

		var label := Label.new()
		label.text = setting_name
		category_container.add_child(label)
		var setting_ui_element := setting.ui_element()
		setting_ui_element.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_SHRINK_END
		category_container.add_child(setting_ui_element)


func did_settings_change() -> bool:
	var is_changed := func(setting: Setting) -> bool: return setting.changed
	var settings_changed := Settings.settings.values().any(is_changed)
	return settings_changed
