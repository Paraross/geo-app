class_name SettingsScreen
extends Screen

signal left(to_main_menu: bool)

var return_to_main_menu: bool

@onready var settings_grid: GridContainer = $CenterContainer/PanelContainer/VBoxContainer/Grid
@onready var settings_container: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer/SettingsContainer

@onready var confirm_popup: PopupPanel = $ConfirmPopup
@onready var button_hbox: HBoxContainer = confirm_popup.get_node("VBox/ButtonHBox")


func on_entered() -> void:
	Settings.set_all_original_values()
	fill_settings_grid()


func on_left() -> void:
	pass


func fill_settings_grid() -> void:
	for child in settings_container.get_children():
		child.queue_free()

	var category_containers: Dictionary[String, Container] = {}

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
			settings_container.add_child(new_category_container)
			category_container = new_category_container

		var label := Label.new()
		label.text = setting_name.capitalize()
		category_container.add_child(label)
		category_container.add_child(setting.ui_element())


func settings_changed() -> bool:
	var is_changed := func(setting: Setting) -> bool: return setting.changed
	var settings_changed := Settings.settings.values().any(is_changed)
	return settings_changed


func leave_to_last() -> void:
	leave_screen(false)


func leave_to_main_menu() -> void:
	leave_screen(true)


func leave_screen(to_main_menu: bool) -> void:
	if settings_changed():
		return_to_main_menu = to_main_menu
		confirm_popup.show()
	else:
		left.emit(to_main_menu)


func _on_yes_button_pressed() -> void:
	Settings.save_settings_to_file()
	confirm_popup.hide()
	left.emit(return_to_main_menu)


func _on_no_button_pressed() -> void:
	Settings.reset_all_to_original()
	confirm_popup.hide()
	left.emit(return_to_main_menu)


func _on_cancel_button_pressed() -> void:
	confirm_popup.hide()
