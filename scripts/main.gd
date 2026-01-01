class_name Main
extends Control

var last_screen: Screen

var current_screen: Screen:
	set(value):
		if current_screen != null:
			current_screen.on_left()
		last_screen = current_screen
		current_screen = value
		current_screen.on_entered()
		disable_screens()
		enable_current_screen()

@onready var task_screen: Screen = $TaskScreen
@onready var task_filter_screen: Screen = $TaskFilterScreen
@onready var playground_screen: Screen = $PlaygroundScreen
@onready var settings_screen: Screen = $SettingsScreen
@onready var formulas_screen: Screen = $ExploreScreen
@onready var main_menu_screen: Screen = $MainMenuScreen


func _ready() -> void:
	current_screen = main_menu_screen
	disable_screens()
	enable_current_screen()


func disable_screens() -> void:
	for screen: Screen in screens():
		screen.visible = false
		screen.set_process_input(false)
		screen.process_mode = Node.PROCESS_MODE_DISABLED


func enable_current_screen() -> void:
	current_screen.visible = true
	current_screen.set_process_input(true)
	current_screen.process_mode = Node.PROCESS_MODE_INHERIT


func screens() -> Array:
	return [
		task_screen,
		task_filter_screen,
		playground_screen,
		settings_screen,
		formulas_screen,
		main_menu_screen,
	]


func go_to_main_menu() -> void:
	current_screen = main_menu_screen


func go_to_tasks() -> void:
	current_screen = task_filter_screen


func go_to_explore() -> void:
	current_screen = formulas_screen


func go_to_playground() -> void:
	current_screen = playground_screen


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func _on_main_menu_start_button_pressed() -> void:
	current_screen = task_filter_screen


func _on_settings_button_pressed() -> void:
	current_screen = settings_screen


func _on_task_filter_start_button_pressed() -> void:
	var ts := task_screen as ScreenWithTopBar
	var tss := ts.screen as TaskScreen
	var tfs := task_filter_screen as ScreenWithTopBar
	var tfss := tfs.screen as TaskFilterScreen

	tss.reset()

	tss.selected_task = tfss.selected_task()

	current_screen = ts


func _on_back_button_pressed() -> void:
	current_screen = last_screen


func _on_main_menu_button_pressed() -> void:
	current_screen = main_menu_screen


func _on_formulas_button_pressed() -> void:
	current_screen = formulas_screen


func _on_settings_screen_left(to_main_menu: bool) -> void:
	current_screen = main_menu_screen if to_main_menu else last_screen


func _on_playground_button_pressed() -> void:
	current_screen = playground_screen
