extends Node

@export var current_screen: Control:
	set(value):
		current_screen = value
		make_current_screen_visible()
		# print("current_screen changed to %s" % current_screen)

@onready var task_screen: HBoxContainer = $TaskScreen
@onready var shape_world: ShapeWorld = $TaskScreen/ShapeViewportContainer/ShapeViewport/ShapeWorld
@onready var task_vbox: VBoxContainer = $TaskScreen/PanelContainer/VBoxContainer
@onready var task_data_grid: GridContainer = task_vbox.get_node("TaskDataGrid")
@onready var task_answer_grid: GridContainer = task_vbox.get_node("TaskAnswerGrid")
@onready var area_spin_box: SpinBox = task_answer_grid.get_node("AreaSpinBox")
@onready var volume_spin_box: SpinBox = task_answer_grid.get_node("VolumeSpinBox")

@onready var task_filter_menu: Control = $TaskFilterMenu
@onready var task_filter_vbox: VBoxContainer = task_filter_menu.get_node("CenterContainer/PanelContainer/VBoxContainer")
@onready var difficulty_list: ItemList = task_filter_vbox.get_node("GridContainer/DifficultyList") 
@onready var task_list: ItemList = task_filter_vbox.get_node("GridContainer/TaskList") 

func _ready() -> void:
	make_children_not_visible()
	make_current_screen_visible()

	initialize_difficulty_list()

func _on_button_pressed() -> void:
	shape_world.spawn_new_task()
	
	for child in task_data_grid.get_children():
		assert(child is Label or child is SpinBox)
		child.queue_free()
	
	for value_pair: Array in shape_world.current_task.values():
		var value_name: String = value_pair[0]
		var value_value: float = value_pair[1]
		
		var label := Label.new()
		label.text = value_name
		task_data_grid.add_child(label)
		
		var spin_box := SpinBox.new()
		spin_box.editable = false
		spin_box.step = 0.1
		spin_box.value = value_value
		task_data_grid.add_child(spin_box)


func _on_check_answer_button_pressed() -> void:
	if shape_world.current_task == null:
		print("no task")
		return
	
	var correct_area := Global.round_task_answer(shape_world.current_task.correct_area())
	var correct_volume := Global.round_task_answer(shape_world.current_task.correct_volume())
	
	var entered_area := area_spin_box.value
	var entered_volume := volume_spin_box.value
	
	print("correct area: %s" % correct_area)
	print("correct volume: %s" % correct_volume)
	
	if is_equal_approx(entered_area, correct_area):
		print("correct area")
	else:
		print("incorrect area")
		print(shape_world.current_task.area_tip())
	
	if is_equal_approx(entered_volume, correct_volume):
		print("correct volume")
	else:
		print("incorrect volume")
		print(shape_world.current_task.volume_tip())
	
	print()


func make_children_not_visible() -> void:
	for child: Control in get_children():
		child.visible = false


func make_current_screen_visible() -> void:
	current_screen.visible = true


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func _on_start_button_pressed() -> void:
	make_children_not_visible()
	current_screen = task_filter_menu


# TODO: move out of main

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


func _on_difficulty_item_list_multi_selected(_index: int, _selected: bool) -> void:
	fill_task_list()


func _on_task_filter_start_button_pressed() -> void:
	var selected_task_indices := task_list.get_selected_items()

	if selected_task_indices.is_empty():
		print("no task selected")
		return

	var selected_tasks: Array[Task] = []
	for index in selected_task_indices:
		var raw_name := Tasks.deniceify_name(task_list.get_item_text(index))
		for task in Tasks.all_tasks:
			if task.name == raw_name:
				selected_tasks.push_back(task)

	shape_world.available_tasks = selected_tasks

	make_children_not_visible()
	current_screen = task_screen
