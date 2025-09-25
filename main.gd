extends Node

@onready var shape_world: ShapeWorld = $HBoxContainer/ShapeViewportContainer/ShapeViewport/ShapeWorld

@onready var task_data_grid: GridContainer = $HBoxContainer/PanelContainer/VBoxContainer/TaskDataGrid
@onready var side_spin_box: SpinBox = task_data_grid.get_node("SideSpinBox")
@onready var area_spin_box: SpinBox = task_data_grid.get_node("AreaSpinBox")
@onready var volume_spin_box: SpinBox = task_data_grid.get_node("VolumeSpinBox")

@onready var check_answer_button: Button = $HBoxContainer/PanelContainer/VBoxContainer/CheckAnswerButton
@onready var new_task_button: Button = $HBoxContainer/PanelContainer/VBoxContainer/NewTaskButton

func _on_button_pressed() -> void:
	shape_world.spawn_new_task()
	$HBoxContainer/PanelContainer/VBoxContainer/TaskDataGrid/SideLabel.text = shape_world.current_task.values()[0][0]
	side_spin_box.value = shape_world.current_task.values()[0][1]


func _on_check_answer_button_pressed() -> void:
	if shape_world.current_task == null:
		print("no task")
		return
	
	var correct_area := shape_world.current_task.correct_area()
	var correct_volume := shape_world.current_task.correct_volume()
	
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
