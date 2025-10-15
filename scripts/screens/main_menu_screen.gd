class_name MainMenuScreen
extends Screen

@onready var start_button: Button = $CenterContainer/PanelContainer/VBoxContainer/StartButton
@onready var settings_button: Button = $CenterContainer/PanelContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/VBoxContainer/QuitButton

func _input(event: InputEvent) -> void:
	var should_focus_start_button := event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_down")
	var should_focus_quit_button := event.is_action_pressed("ui_focus_prev") or event.is_action_pressed("ui_up")
	var any_button_has_focus := start_button.has_focus() or settings_button.has_focus() or quit_button.has_focus()

	if not any_button_has_focus:
		if should_focus_start_button:
			start_button.grab_focus.call_deferred()
		elif should_focus_quit_button:
			quit_button.grab_focus.call_deferred()


func on_entered() -> void:
	pass


func on_left() -> void:
	pass
