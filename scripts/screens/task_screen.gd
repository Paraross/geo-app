class_name TaskScreen
extends Screen

var selected_task: Task

var current_step: int = 0

@onready var task_environment: TaskEnvironment = $HBoxContainer/ShapeViewportContainer/ShapeViewport/TaskEnvironment
@onready var task_vbox: VBoxContainer = $HBoxContainer/PanelContainer/VBoxContainer

@onready var task_data_grid: GridContainer = task_vbox.get_node("TaskDataGrid")

@onready var step_nav_hbox: HBoxContainer = task_vbox.get_node("StepNavHbox")
@onready var prev_step_button: Button = step_nav_hbox.get_node("PrevButton")
@onready var next_step_button: Button = step_nav_hbox.get_node("NextButton")
@onready var step_title_label: Label = step_nav_hbox.get_node("Label")

@onready var steps_vbox: VBoxContainer = task_vbox.get_node("StepsScroll/StepsVBox")

@onready var check_answer_button: Button = task_vbox.get_node("CheckAnswerButton")
@onready var final_label: Label = task_vbox.get_node("FinalLabel")

@onready var tip_popup: PopupPanel = $TipPopup
@onready var tip_popup_label: Label = tip_popup.get_node("TipLabel")


func on_entered() -> void:
	get_new_task()


func on_left() -> void:
	reset()


func reset() -> void:
	Global.clear_grid(task_data_grid)
	task_environment.unload_current_task()
	check_answer_button.disabled = true
	final_label.text = ""
	current_step = 0


func update_step_nav_ui() -> void:
	var task := task_environment.task

	var steps := task.step_count()
	current_step = clamp(current_step, 0, max(0, steps - 1))
	step_title_label.text = task.step_title(current_step)
	prev_step_button.disabled = current_step <= 0

	next_step_button.disabled = current_step >= steps - 1 or not is_current_answer_correct()


func get_new_task() -> void:
	task_environment.spawn_new_task(selected_task)

	Global.clear_grid(task_data_grid)
	check_answer_button.disabled = false
	final_label.text = ""
	current_step = 0

	set_values_ui()

	var task := task_environment.task

	current_step = 0
	step_title_label.text = task.step_title(current_step)
	prev_step_button.disabled = true
	next_step_button.disabled = true

	set_step_ui()


func set_values_ui() -> void:
	var values := task_environment.task.values()
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

	var i := 1
	for step in task_environment.task.steps():
		var title_label := Label.new()
		title_label.text = "%s. %s" % [i, step.title]

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
		answer_spinbox.min_value = -1000.0
		answer_spinbox.max_value = 1000.0
		answer_spinbox.value = step.correct_answer() # TODO: remove in final version
		answer_spinbox.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN

		var answer_mark_label := Label.new()
		answer_mark_label.visible = false

		var answer_hbox := HBoxContainer.new()
		answer_hbox.add_child(answer_spinbox)
		answer_hbox.add_child(answer_mark_label)

		var step_vbox := VBoxContainer.new()
		step_vbox.add_child(title_hbox)
		step_vbox.add_child(answer_hbox)

		steps_vbox.add_child(step_vbox)

		i += 1

	update_step_ui()


func update_step_ui() -> void:
	var i := 0
	for step_container: Container in steps_vbox.get_children():
		step_container.visible = i <= current_step

		var answer_hbox: HBoxContainer = step_container.get_child(1)
		var answer_spinbox: SpinBox = answer_hbox.get_child(0)
		answer_spinbox.editable = i == current_step

		i += 1


func is_current_answer_correct() -> bool:
	if task_environment.task.steps().is_empty():
		return false

	var correct_answer := task_environment.task.steps()[current_step].correct_answer()

	if steps_vbox.get_children().is_empty():
		return false

	var step_container: Container = steps_vbox.get_children()[current_step]

	var answer_hbox: HBoxContainer = step_container.get_child(1)
	var answer_spinbox: SpinBox = answer_hbox.get_child(0)

	return is_equal_approx(answer_spinbox.value, correct_answer)


func _on_prev_step_pressed() -> void:
	if current_step > 0:
		current_step -= 1
		update_step_nav_ui()
		update_step_ui()


func _on_next_step_pressed() -> void:
	var steps := task_environment.task.step_count()
	if current_step < steps - 1:
		current_step += 1
		update_step_nav_ui()
		update_step_ui()


func _on_check_answer_button_pressed() -> void:
	var correct_answer := task_environment.task.steps()[current_step].correct_answer()

	var step_container: Container = steps_vbox.get_children()[current_step]
	var answer_hbox: HBoxContainer = step_container.get_child(1)
	var answer_spinbox: SpinBox = answer_hbox.get_child(0)
	var answer_mark_label: Label = answer_hbox.get_child(1)

	var is_answer_correct := is_equal_approx(answer_spinbox.value, correct_answer)

	answer_mark_label.text = "️✅" if is_answer_correct else "❌"
	answer_mark_label.visible = true

	update_step_nav_ui()

	var is_last_step := current_step == task_environment.task.step_count() - 1
	if is_answer_correct and is_last_step:
		check_answer_button.disabled = true
		final_label.text = "Task complete!"


func _on_new_task_button_pressed() -> void:
	get_new_task()
