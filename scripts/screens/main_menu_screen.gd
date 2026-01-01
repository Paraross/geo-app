class_name MainMenuScreen
extends Screen

signal tasks_button_pressed
signal explore_button_pressed
signal playground_button_pressed
signal settings_button_pressed

@onready var buttons_container: Container = $CenterContainer/PanelContainer/VBox/Buttons


func _input(event: InputEvent) -> void:
	var buttons := buttons_container.get_children()

	var any_button_has_focus := buttons.any(func(button: Button) -> bool: return button.has_focus())

	var first_button: Button = buttons.front()
	var last_button: Button = buttons.back()

	if is_ui_next_pressed(event) and (not any_button_has_focus or last_button.has_focus()):
		first_button.grab_focus.call_deferred()
	elif is_ui_prev_pressed(event) and (not any_button_has_focus or first_button.has_focus()):
		last_button.grab_focus.call_deferred()


func on_entered() -> void:
	pass


func on_left() -> void:
	pass


func is_ui_next_pressed(event: InputEvent) -> bool:
	return event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_down")


func is_ui_prev_pressed(event: InputEvent) -> bool:
	return event.is_action_pressed("ui_focus_prev") or event.is_action_pressed("ui_up")


func _on_tasks_button_pressed() -> void:
	tasks_button_pressed.emit()


func _on_explore_button_pressed() -> void:
	explore_button_pressed.emit()


func _on_playground_button_pressed() -> void:
	playground_button_pressed.emit()


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
