class_name TaskScreen
extends Screen

var selected_task: Task

var current_step: int = 0

@onready var task_environment: TaskEnvironment = $HBoxContainer/ShapeViewportContainer/ShapeViewport/TaskEnvironment
@onready var task_vbox: VBoxContainer = $HBoxContainer/PanelContainer/VBoxContainer

@onready var description_label: RichTextLabel = $HBoxContainer/PanelContainer/VBoxContainer/DescriptionLabel

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

	check_answer_button.disabled = false
	final_label.text = ""
	current_step = 0

	set_description_label()

	var task := task_environment.task

	current_step = 0
	step_title_label.text = task.step_title(current_step)
	prev_step_button.disabled = true
	next_step_button.disabled = true

	set_step_ui()


func set_description_label() -> void:
	var task := task_environment.task
	var task_values := task.values()

	var values: Dictionary[String, float] = { }
	for value_name in task_values:
		values[value_name] = task_values[value_name].value

	description_label.text = task.description().format(values)


func set_step_ui() -> void:
	for child in steps_vbox.get_children():
		child.queue_free()
		steps_vbox.remove_child(child)

	var i := 1
	for step in task_environment.task.steps():
		var step_container_scene: PackedScene = preload("res://scenes/step_container.tscn").duplicate_deep()
		var step_container: StepContainer = step_container_scene.instantiate()
		steps_vbox.add_child(step_container)

		step_container.title_label.text = "%s. %s" % [i, step.title]
		step_container.tip_button.pressed.connect(
			func() -> void:
				tip_popup_label.text = step.tip
				tip_popup.position = step_container.tip_button.global_position
				tip_popup.size = tip_popup_label.get_combined_minimum_size()
				tip_popup.show()
		)
		step_container.answer_spinbox.step = 1.0 / 10.0 ** step.answer_precision_digits
		step_container.answer_spinbox.value = step.correct_answer() # TODO: remove in final version

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

	var step_container: StepContainer = steps_vbox.get_children()[current_step]
	var answer_spinbox: SpinBox = step_container.answer_spinbox
	var answer_mark_label: Label = step_container.answer_mark_label

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
