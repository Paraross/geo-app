class_name SettingsScreen
extends Screen

signal left(to_main_menu: bool)

var return_to_main_menu: bool

@onready var settings_grid: GridContainer = $CenterContainer/PanelContainer/VBoxContainer/Grid

@onready var confirm_popup: PopupPanel = $ConfirmPopup
@onready var button_hbox: HBoxContainer = confirm_popup.get_node("VBox/ButtonHBox")

func on_entered() -> void:
	Settings.set_all_original_values()
	fill_settings_grid()


func on_left() -> void:
	pass


func fill_settings_grid() -> void:
	Global.clear_grid(settings_grid)
	for setting_name in Settings.settings:
		var setting := Settings.settings[setting_name]

		var label := Label.new()
		label.text = setting_name.capitalize()
		settings_grid.add_child(label)

		settings_grid.add_child(setting.ui_element())
	

func settings_changed() -> bool:
	var is_changed := func (setting: Setting) -> bool: return setting.changed
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
