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

@onready var task_filter_menu: TaskFilterMenu = $TaskFilterMenu

func _ready() -> void:
	make_children_not_visible()
	make_current_screen_visible()


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


func _on_main_menu_start_button_pressed() -> void:
	make_children_not_visible()
	current_screen = task_filter_menu


func _on_task_filter_start_button_pressed() -> void:
	var selected_tasks := task_filter_menu.selected_tasks()
	shape_world.available_tasks = selected_tasks

	make_children_not_visible()
	current_screen = task_screen
