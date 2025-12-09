class_name TaskScreen
extends Screen

var available_tasks: Array[Task]

var current_step: int = 0

@onready var shape_world: ShapeWorld = $HBoxContainer/ShapeViewportContainer/ShapeViewport/ShapeWorld
@onready var task_vbox: VBoxContainer = $HBoxContainer/PanelContainer/VBoxContainer

@onready var task_data_grid: GridContainer = task_vbox.get_node("TaskDataGrid")

@onready var step_nav_hbox: HBoxContainer = task_vbox.get_node("StepNavHbox")
@onready var prev_step_button: Button = step_nav_hbox.get_node("PrevButton")
@onready var next_step_button: Button = step_nav_hbox.get_node("NextButton")
@onready var step_title_label: Label = step_nav_hbox.get_node("Label")

@onready var steps_vbox: VBoxContainer = task_vbox.get_node("StepsVBox")

@onready var check_answer_button: Button = task_vbox.get_node("CheckAnswerButton")

@onready var tip_popup: PopupPanel = $TipPopup
@onready var tip_popup_label: Label = tip_popup.get_node("TipLabel")


func on_entered() -> void:
	get_new_task()


func on_left() -> void:
	reset()


func reset() -> void:
	# area_spin_box.value = 0.0
	# volume_spin_box.value = 0.0
	# area_result_label.text = ""
	# volume_result_label.text = ""
	# area_result_tip_button.visible = false
	# volume_result_tip_button.visible = false
	Global.clear_grid(task_data_grid)
	shape_world.reset_current_task()
	check_answer_button.disabled = true
	current_step = 0
	if step_nav_hbox != null:
		step_nav_hbox.visible = false


func update_step_nav_ui() -> void:
	var task := shape_world.current_task
	var has_task := task != null
	step_nav_hbox.visible = has_task

	if not has_task:
		return

	var steps := task.step_count()
	current_step = clamp(current_step, 0, max(0, steps - 1))
	step_title_label.text = task.step_title(current_step)
	prev_step_button.disabled = current_step <= 0
	next_step_button.disabled = current_step >= steps - 1


func clear_results() -> void:
	pass
	# area_result_label.text = ""
	# volume_result_label.text = ""
	# area_result_tip_button.visible = false
	# volume_result_tip_button.visible = false


func set_answer_labels() -> void:
	var task := shape_world.current_task

	if task == null:
		return

	# var is_volume_step := current_step == task.step_count() - 1
	#
	# var correct_answer := Global.round_task_answer(task.correct_answer_for_step(current_step))

	# if not is_volume_step:
	# 	var entered_area := area_spin_box.value
	# 	if is_equal_approx(entered_area, correct_answer):
	# 		area_result_label.text = "The answer is correct"
	# 		area_result_tip_button.visible = false
	# 	else:
	# 		area_result_label.text = "The answer is incorrect"
	# 		area_result_tip_button.visible = true
	# 	if OS.is_debug_build():
	# 		var correct_answer_str := " (%s)"
	# 		area_result_label.text += correct_answer_str % correct_answer
	# 	# Hide volume result on area steps
	# 	volume_result_hbox.visible = false
	# else:
	# 	var entered_volume := volume_spin_box.value
	# 	if is_equal_approx(entered_volume, correct_answer):
	# 		volume_result_label.text = "The volume is correct"
	# 		volume_result_tip_button.visible = false
	# 	else:
	# 		volume_result_label.text = "The volume is incorrect"
	# 		volume_result_tip_button.visible = true
	# 	if OS.is_debug_build():
	# 		var correct_answer_str2 := " (%s)"
	# 		volume_result_label.text += correct_answer_str2 % correct_answer
	# 	# Hide area result on volume step
	# 	area_result_hbox.visible = false


func get_new_task() -> void:
	shape_world.spawn_new_task(available_tasks)

	Global.clear_grid(task_data_grid)
	check_answer_button.disabled = false
	current_step = 0

	set_values_ui()
	update_step_nav_ui()
	set_step_ui()


func set_values_ui() -> void:
	var values := shape_world.current_task.values()
	for value_name in values:
		var value_value := values[value_name].value

		var name_label := Label.new()
		name_label.text = "• %s" % value_name

		var value_label := Label.new()
		value_label.text = " = %s" % value_value

		task_data_grid.add_child(name_label)
		task_data_grid.add_child(value_label)


func set_step_ui() -> void:
	for child in steps_vbox.get_children():
		child.queue_free()
		steps_vbox.remove_child(child)

	for step in shape_world.current_task.steps():
		var title_label := Label.new()
		title_label.text = step.title

		var tip_button := Button.new()
		tip_button.theme_type_variation = "TipButton"
		tip_button.text = "?"
		tip_button.pressed.connect(
			func() -> void:
				tip_popup_label.text = step.tip
				tip_popup.position = tip_button.global_position
				tip_popup.size = tip_popup_label.get_combined_minimum_size()
				tip_popup.show()
		)

		var title_hbox := HBoxContainer.new()
		title_hbox.add_child(title_label)
		title_hbox.add_child(tip_button)

		var answer_spinbox := SpinBox.new()
		answer_spinbox.step = 1.0 / 10.0 ** Settings.answer_precision
		answer_spinbox.value = step.correct_answer()

		var step_vbox := VBoxContainer.new()
		step_vbox.add_child(title_hbox)
		step_vbox.add_child(answer_spinbox)

		steps_vbox.add_child(step_vbox)

	update_step_ui()


func update_step_ui() -> void:
	var i := 0
	# only elements related to current and earlier steps are visible
	for step_container: Container in steps_vbox.get_children():
		step_container.visible = i <= current_step
		i += 1


func _on_area_result_tip_button_pressed() -> void:
	tip_popup_label.text = shape_world.current_task.tip_for_step(current_step)
	tip_popup.show()


func _on_volume_result_tip_button_pressed() -> void:
	tip_popup_label.text = shape_world.current_task.tip_for_step(current_step)
	tip_popup.show()


func _on_prev_step_pressed() -> void:
	if current_step > 0:
		current_step -= 1
		clear_results()
		update_step_nav_ui()
		update_step_ui()


func _on_next_step_pressed() -> void:
	var steps := shape_world.current_task.step_count()
	if current_step < steps - 1:
		current_step += 1
		clear_results()
		update_step_nav_ui()
		update_step_ui()


func _on_check_answer_button_pressed() -> void:
	assert(shape_world.current_task != null)
	set_answer_labels()


func _on_new_task_button_pressed() -> void:
	get_new_task()
