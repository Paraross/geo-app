extends Node

@export var current_screen: Screen:
	set(value):
		if current_screen != null:
			current_screen.on_left()
		last_screen = current_screen
		current_screen = value
		current_screen.on_entered()
		disable_screens()
		enable_current_screen()

var last_screen: Screen

@onready var main_content: Control = $AppVBox/MainContent
@onready var task_screen: TaskScreen = main_content.get_node("TaskScreen")
@onready var task_filter_screen: TaskFilterScreen = main_content.get_node("TaskFilterScreen")
@onready var playground_screen: PlaygroundScreen = main_content.get_node("PlaygroundScreen")
@onready var settings_screen: SettingsScreen = main_content.get_node("SettingsScreen")
@onready var formulas_screen: FormulasScreen = main_content.get_node("TopBarScreenVBox/FormulasScreen")
@onready var main_menu_screen: MainMenuScreen = main_content.get_node("MainMenuScreen")


func _ready() -> void:
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
	# TODO: ?
	if main_content == null:
		return []

	return [
		task_screen,
		task_filter_screen,
		playground_screen,
		settings_screen,
		formulas_screen,
		main_menu_screen,
	]

	# return main_content.get_children().filter(func(child: Node) -> bool: return child is Screen)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func _on_main_menu_start_button_pressed() -> void:
	current_screen = task_filter_screen


func _on_settings_button_pressed() -> void:
	current_screen = settings_screen


func _on_task_filter_start_button_pressed() -> void:
	task_screen.reset()

	task_screen.selected_task = task_filter_screen.selected_task()

	current_screen = task_screen


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
