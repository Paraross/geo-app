class_name ScreenWithTopBar
extends Screen

var screen: Screen

@onready var main: Main = get_parent()

@onready var top_bar: Container = $PanelContainer/TopBarHBox
@onready var main_menu_button: Button = top_bar.get_node("MainMenuButton")
@onready var tasks_button: Button = top_bar.get_node("TasksButton")
@onready var explore_button: Button = top_bar.get_node("ExploreButton")
@onready var playground_button: Button = top_bar.get_node("PlaygroundButton")
@onready var settings_button: Button = top_bar.get_node("SettingsButton")


func _ready() -> void:
	find_and_set_screen()
	connect_signals()


func on_entered() -> void:
	set_top_bar_button_disabled()
	screen.on_entered()


func on_left() -> void:
	screen.on_left()


func find_and_set_screen() -> void:
	for child: Control in get_children():
		if child is Screen:
			screen = child
			break


func set_top_bar_button_disabled() -> void:
	# bad code
	tasks_button.disabled = false
	explore_button.disabled = false
	playground_button.disabled = false
	settings_button.disabled = false

	match self:
		main.task_filter_screen:
			tasks_button.disabled = true
		main.formulas_screen:
			explore_button.disabled = true
		main.playground_screen:
			playground_button.disabled = true
		main.settings_screen:
			settings_button.disabled = true


func connect_signals() -> void:
	main_menu_button.pressed.connect(main.go_to_main_menu)
	tasks_button.pressed.connect(main.go_to_task_filter)
	explore_button.pressed.connect(main.go_to_explore)
	playground_button.pressed.connect(main.go_to_playground)
	settings_button.pressed.connect(main.go_to_settings)
