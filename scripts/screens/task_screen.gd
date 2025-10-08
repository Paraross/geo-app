class_name TaskScreen
extends Screen

var available_tasks: Array[Task]

@onready var shape_world: ShapeWorld = $"HBoxContainer/ShapeViewportContainer/ShapeViewport/ShapeWorld"
@onready var task_vbox: VBoxContainer = $"HBoxContainer/PanelContainer/VBoxContainer"
@onready var task_data_grid: GridContainer = task_vbox.get_node("TaskDataGrid")
@onready var task_answer_grid: GridContainer = task_vbox.get_node("TaskAnswerGrid")
@onready var area_spin_box: SpinBox = task_answer_grid.get_node("AreaSpinBox")
@onready var volume_spin_box: SpinBox = task_answer_grid.get_node("VolumeSpinBox")
@onready var area_result_label: Label = task_answer_grid.get_node("AreaResultLabel")
@onready var volume_result_label: Label = task_answer_grid.get_node("VolumeResultLabel")

func on_entered() -> void:
	var answer_step := 1.0 / 10.0 ** Settings.answer_precision
	area_spin_box.step = answer_step
	volume_spin_box.step = answer_step


func on_left() -> void:
	pass


func reset() -> void:
	area_spin_box.value = 0.0
	volume_spin_box.value = 0.0
	clear_task_data_grid()
	shape_world.reset_current_task()


func clear_task_data_grid() -> void:
	for child in task_data_grid.get_children():
		assert(child is Label or child is SpinBox)
		child.queue_free()


func _on_check_answer_button_pressed() -> void:
	if shape_world.current_task == null:
		print("no task")
		return
	
	var correct_area := Global.round_task_answer(shape_world.current_task.correct_area())
	var correct_volume := Global.round_task_answer(shape_world.current_task.correct_volume())
	
	var entered_area := area_spin_box.value
	var entered_volume := volume_spin_box.value
	
	if is_equal_approx(entered_area, correct_area):
		area_result_label.text = "The area is correct"
	else:
		area_result_label.text = "The area is incorrect"
		print(shape_world.current_task.area_tip())
	
	if is_equal_approx(entered_volume, correct_volume):
		volume_result_label.text = "The volume is correct"
	else:
		volume_result_label.text = "The volume is incorrect"
		print(shape_world.current_task.volume_tip())

	if OS.is_debug_build():
		area_result_label.text += " (%s)" % correct_area
		volume_result_label.text += " (%s)" % correct_volume
	
	print()


func _on_new_task_button_pressed() -> void:
	shape_world.spawn_new_task(available_tasks)
	
	clear_task_data_grid()
	
	for value_pair: Array in shape_world.current_task.values():
		var value_name: String = value_pair[0]
		var value_value: float = value_pair[1]
		
		var label := Label.new()
		label.text = value_name
		task_data_grid.add_child(label)
		
		var spin_box := SpinBox.new()
		spin_box.editable = false
		spin_box.step = 1.0 / 10.0 ** Settings.data_precision
		spin_box.value = value_value
		task_data_grid.add_child(spin_box)
