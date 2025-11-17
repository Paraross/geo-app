class_name TaskScreen
extends Screen

var available_tasks: Array[Task]

@onready var shape_world: ShapeWorld = $HBoxContainer/ShapeViewportContainer/ShapeViewport/ShapeWorld
@onready var task_vbox: VBoxContainer = $HBoxContainer/PanelContainer/VBoxContainer

@onready var task_data_grid: GridContainer = task_vbox.get_node("TaskDataGrid")
@onready var task_answer_grid: GridContainer = task_vbox.get_node("TaskAnswerGrid")

@onready var area_spin_box: SpinBox = task_answer_grid.get_node("AreaSpinBox")
@onready var volume_spin_box: SpinBox = task_answer_grid.get_node("VolumeSpinBox")

@onready var area_result_hbox: HBoxContainer = task_answer_grid.get_node("AreaResultHbox")
@onready var area_result_label: Label = area_result_hbox.get_node("Label")
@onready var area_result_tip_button: Button = area_result_hbox.get_node("Button")

@onready var volume_result_hbox: HBoxContainer = task_answer_grid.get_node("VolumeResultHbox")
@onready var volume_result_label: Label = volume_result_hbox.get_node("Label")
@onready var volume_result_tip_button: Button = volume_result_hbox.get_node("Button")

@onready var check_answer_button: Button = task_vbox.get_node("CheckAnswerButton")

@onready var tip_popup: PopupPanel = $TipPopup
@onready var tip_popup_label: Label = $TipPopup/TipLabel


func on_entered() -> void:
	var answer_step := 1.0 / 10.0 ** Settings.answer_precision
	area_spin_box.step = answer_step
	volume_spin_box.step = answer_step


func on_left() -> void:
	shape_world.reset_current_task()


func reset() -> void:
	area_spin_box.value = 0.0
	volume_spin_box.value = 0.0
	area_result_label.text = ""
	volume_result_label.text = ""
	area_result_tip_button.visible = false
	volume_result_tip_button.visible = false
	Global.clear_grid(task_data_grid)
	shape_world.reset_current_task()
	check_answer_button.disabled = true


# TODO: set color
func set_answer_labels() -> void:
	var correct_area := Global.round_task_answer(shape_world.current_task.correct_area())
	var correct_volume := Global.round_task_answer(shape_world.current_task.correct_volume())

	var entered_area := area_spin_box.value
	var entered_volume := volume_spin_box.value

	# area
	if is_equal_approx(entered_area, correct_area):
		area_result_label.text = "The area is correct"
		area_result_tip_button.visible = false
	else:
		area_result_label.text = "The area is incorrect"
		area_result_tip_button.visible = true
	# volume
	if is_equal_approx(entered_volume, correct_volume):
		volume_result_label.text = "The volume is correct"
		volume_result_tip_button.visible = false
	else:
		volume_result_label.text = "The volume is incorrect"
		volume_result_tip_button.visible = true

	if OS.is_debug_build():
		var correct_answer_str := " (%s)"
		area_result_label.text += correct_answer_str % correct_area
		volume_result_label.text += correct_answer_str % correct_volume


func _on_check_answer_button_pressed() -> void:
	assert(shape_world.current_task != null)
	set_answer_labels()


func _on_new_task_button_pressed() -> void:
	shape_world.spawn_new_task(available_tasks)

	Global.clear_grid(task_data_grid)
	check_answer_button.disabled = false

	var values := shape_world.current_task.values()
	for value_name in values:
		var value_value: TaskFloatValue = values[value_name]

		var label := Label.new()
		label.text = value_name
		task_data_grid.add_child(label)

		var spin_box := SpinBox.new()
		spin_box.editable = false
		spin_box.step = 1.0 / 10.0 ** Settings.data_precision
		spin_box.value = value_value.value
		task_data_grid.add_child(spin_box)


func _on_area_result_tip_button_pressed() -> void:
	tip_popup_label.text = shape_world.current_task.area_tip()
	tip_popup.show()


func _on_volume_result_tip_button_pressed() -> void:
	tip_popup_label.text = shape_world.current_task.volume_tip()
	tip_popup.show()
