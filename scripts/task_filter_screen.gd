class_name TaskFilterScreen
extends Control

@onready var task_filter_vbox: VBoxContainer = $"CenterContainer/PanelContainer/VBoxContainer"
@onready var difficulty_list: ItemList = task_filter_vbox.get_node("GridContainer/DifficultyList") 
@onready var task_list: ItemList = task_filter_vbox.get_node("GridContainer/TaskList") 

func _ready() -> void:
	initialize_difficulty_list()


func initialize_difficulty_list() -> void:
	for difficulty_name: String in Global.TaskDifficulty.keys():
		difficulty_list.add_item(difficulty_name.capitalize())
	
	# select all by default
	for i in range(difficulty_list.item_count):
		difficulty_list.select(i, false)
	
	fill_task_list()


func fill_task_list() -> void:
	var selected_difficulty_indices := difficulty_list.get_selected_items()

	task_list.clear()
	for task in Tasks.all_tasks:
		var task_difficulty_is_selected := selected_difficulty_indices.find(task.difficulty()) != -1
		if task_difficulty_is_selected:
			var nice_name := Tasks.niceify_name(task.name)
			assert(Tasks.deniceify_name(nice_name) == task.name)
			task_list.add_item(nice_name)
	
	for i in range(task_list.item_count):
		task_list.select(i, false)


func selected_tasks() -> Array[Task]:
	var selected_task_indices := task_list.get_selected_items()

	if selected_task_indices.is_empty():
		return []

	var selected_tasks1: Array[Task] = []
	for index in selected_task_indices:
		var raw_name := Tasks.deniceify_name(task_list.get_item_text(index))
		for task in Tasks.all_tasks:
			if task.name == raw_name:
				selected_tasks1.push_back(task)

	return selected_tasks1


func _on_difficulty_item_list_multi_selected(_index: int, _selected: bool) -> void:
	fill_task_list()
