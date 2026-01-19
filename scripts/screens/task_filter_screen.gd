class_name TaskFilterScreen
extends Screen

# TODO: dodac top bara, zrobic zeby sensownie wyglodalo

signal start_button_pressed

@onready var task_filter_vbox: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer
@onready var difficulty_list: ItemList = task_filter_vbox.get_node("GridContainer/DifficultyList")
@onready var task_list: ItemList = task_filter_vbox.get_node("GridContainer/TaskList")
@onready var task_settings_popup: PopupPanel = $TaskSettingsPopup
@onready var task_settings_popup_vbox: VBoxContainer = task_settings_popup.get_node("VBox")
@onready var task_settings_popup_label: Label = task_settings_popup_vbox.get_node("Label")
@onready var task_settings_popup_grid: GridContainer = task_settings_popup_vbox.get_node("TaskValueGrid")
@onready var start_button: Button = task_filter_vbox.get_node("StartButton")


func on_entered() -> void:
	pass


func on_left() -> void:
	pass


func _ready() -> void:
	initialize_difficulty_list()


func initialize_difficulty_list() -> void:
	for difficulty_name: String in Global.TaskDifficulty.keys():
		difficulty_list.add_item(difficulty_name.capitalize())

	difficulty_list.select(0)

	fill_task_list()


func fill_task_list() -> void:
	var selected_difficulty_index := difficulty_list.get_selected_items()[0]

	task_list.clear()
	for task_name in Tasks.all_tasks:
		var task := Tasks.all_tasks[task_name]
		var task_difficulty_is_selected := task.difficulty() == selected_difficulty_index
		if task_difficulty_is_selected:
			task_list.add_item(task_name)


func selected_task() -> Task:
	var selected_task_indices := task_list.get_selected_items()

	var nice_name := task_list.get_item_text(selected_task_indices[0])
	var selected_task := Tasks.all_tasks[nice_name]

	return selected_task


func _on_difficulty_list_item_selected(_index: int) -> void:
	start_button.disabled = true
	start_button.tooltip_text = "Please select a task"
	fill_task_list()


func _on_task_list_item_selected(_index: int) -> void:
	start_button.disabled = false
	start_button.tooltip_text = ""


func _on_start_button_pressed() -> void:
	start_button_pressed.emit()
