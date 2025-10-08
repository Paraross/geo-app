class_name TaskFilterScreen
extends Screen

@onready var task_filter_vbox: VBoxContainer = $"CenterContainer/PanelContainer/VBoxContainer"
@onready var difficulty_list: ItemList = task_filter_vbox.get_node("GridContainer/DifficultyList") 
@onready var task_list: ItemList = task_filter_vbox.get_node("GridContainer/TaskList") 

func on_entered() -> void:
	pass


func on_left() -> void:
	pass


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
	for task_name in Tasks.all_tasks:
		var task := Tasks.all_tasks[task_name]
		var task_difficulty_is_selected := selected_difficulty_indices.find(task.difficulty()) != -1
		if task_difficulty_is_selected:
			task_list.add_item(task_name)
	
	for i in range(task_list.item_count):
		task_list.select(i, false)


func selected_tasks() -> Array[Task]:
	var selected_task_indices := task_list.get_selected_items()

	if selected_task_indices.is_empty():
		return []

	var selected_tasks1: Array[Task] = []
	for index in selected_task_indices:
		var nice_name := task_list.get_item_text(index)
		selected_tasks1.push_back(Tasks.all_tasks[nice_name])

	return selected_tasks1


func _on_difficulty_item_list_multi_selected(_index: int, _selected: bool) -> void:
	fill_task_list()


func _on_task_list_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != MouseButton.MOUSE_BUTTON_RIGHT:
		return

	var task_name := task_list.get_item_text(index)
	print("%s" % task_name)

	var task := Tasks.all_tasks[task_name]
	var f := task.idk()
	f.call("abc")
