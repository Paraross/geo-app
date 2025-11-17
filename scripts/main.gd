extends Node

@export var current_screen: Screen:
	set(value):
		if current_screen != null:
			current_screen.on_left()
		last_screen = current_screen
		current_screen = value
		current_screen.on_entered()
		make_screens_not_visible()
		disable_input_for_screens()
		make_current_screen_visible()
		enable_input_for_current_screen()

var last_screen: Screen

@onready var task_screen: TaskScreen = $TaskScreen
@onready var task_filter_screen: TaskFilterScreen = $TaskFilterScreen
@onready var settings_screen: SettingsScreen = $SettingsScreen
@onready var formulas_screen: FormulasScreen = $FormulasScreen
@onready var main_menu_screen: MainMenuScreen = $MainMenuScreen

func _ready() -> void:
	make_screens_not_visible()
	make_current_screen_visible()


func make_screens_not_visible() -> void:
	for child: Screen in screens():
		child.visible = false


func make_current_screen_visible() -> void:
	current_screen.visible = true


func disable_input_for_screens() -> void:
	for child: Screen in screens():
		set_input_for_screen(child, false)


func enable_input_for_current_screen() -> void:
	set_input_for_screen(current_screen, true)


func set_input_for_screen(screen: Screen, enable: bool) -> void:
	screen.set_process_input(enable)


func screens() -> Array:
	return get_children().filter(func (child: Node) -> bool: return child is Screen)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func _on_main_menu_start_button_pressed() -> void:
	current_screen = task_filter_screen


func _on_main_menu_settings_button_pressed() -> void:
	current_screen = settings_screen


func _on_task_filter_start_button_pressed() -> void:
	task_screen.reset()

	var selected_tasks := task_filter_screen.selected_tasks()
	task_screen.available_tasks = selected_tasks

	current_screen = task_screen


func _on_back_button_pressed() -> void:
	current_screen = last_screen


func _on_main_menu_button_pressed() -> void:
	current_screen = main_menu_screen


func _on_task_screen_settings_button_pressed() -> void:
	current_screen = settings_screen


func _on_formulas_button_pressed() -> void:
	current_screen = formulas_screen


func _on_settings_screen_left(to_main_menu: bool) -> void:
	current_screen = main_menu_screen if to_main_menu else last_screen
