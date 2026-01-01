class_name ScreenWithTopBar
extends Screen

var screen: Screen

@onready var main: Main = get_parent()

@onready var top_bar: Container = $PanelContainer/TopBarHBox
@onready var main_menu_button: Button = top_bar.get_node("MainMenuButton")
@onready var tasks_button: Button = top_bar.get_node("TasksButton")
@onready var explore_button: Button = top_bar.get_node("ExploreButton")
@onready var playground_button: Button = top_bar.get_node("PlaygroundButton")


func _ready() -> void:
	find_and_set_screen()
	connect_signals()


func on_entered() -> void:
	pass


func on_left() -> void:
	pass


func find_and_set_screen() -> void:
	for child: Control in get_children():
		if child is Screen:
			screen = child
			break


func connect_signals() -> void:
	main_menu_button.pressed.connect(main.go_to_main_menu)
	tasks_button.pressed.connect(main.go_to_tasks)
	explore_button.pressed.connect(main.go_to_explore)
	playground_button.pressed.connect(main.go_to_playground)
