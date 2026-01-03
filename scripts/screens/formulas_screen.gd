class_name FormulasScreen
extends Screen

# TODO: Fill InfoVbox with task steps

@onready var task_filter_edit: LineEdit = $PanelContainer/HBox/TaskFilterVBox/TaskFilterEdit
@onready var easy_task_list: ItemList = $PanelContainer/HBox/TaskFilterVBox/EasyTaskList
@onready var medium_task_list: ItemList = $PanelContainer/HBox/TaskFilterVBox/MediumTaskList
@onready var hard_task_list: ItemList = $PanelContainer/HBox/TaskFilterVBox/HardTaskList

@onready var steps_vbox: Container = $PanelContainer/HBox/InfoVBox/StepsScroll/StepsVBox

@onready var task_environment: TaskEnvironment = $PanelContainer/HBox/TaskVBox/SubViewportContainer/SubViewport/TaskEnvironment
@onready var task_data_grid: GridContainer = $PanelContainer/HBox/TaskVBox/TaskDataGrid


func on_entered() -> void:
	task_filter_edit.text = ""
	fill_task_lists()


func on_left() -> void:
	task_environment.unload_current_task()


func fill_task_lists() -> void:
	easy_task_list.clear()
	medium_task_list.clear()
	hard_task_list.clear()

	for task_name in Tasks.all_tasks:
		var task := Tasks.all_tasks[task_name]
		match task.difficulty():
			Global.TaskDifficulty.EASY:
				easy_task_list.add_item(task_name)
			Global.TaskDifficulty.MEDIUM:
				medium_task_list.add_item(task_name)
			Global.TaskDifficulty.HARD:
				hard_task_list.add_item(task_name)


func fill_task_lists_if(condition: Callable) -> void:
	easy_task_list.clear()
	medium_task_list.clear()
	hard_task_list.clear()

	for task_name in Tasks.all_tasks:
		var condition_met: bool = condition.call(task_name)
		if not condition_met:
			continue

		var task := Tasks.all_tasks[task_name]
		match task.difficulty():
			Global.TaskDifficulty.EASY:
				easy_task_list.add_item(task_name)
			Global.TaskDifficulty.MEDIUM:
				medium_task_list.add_item(task_name)
			Global.TaskDifficulty.HARD:
				hard_task_list.add_item(task_name)


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
		step_container.tip_button.tip_text = step.tip
		step_container.answer_spinbox.step = 1.0 / 10.0 ** step.answer_precision_digits
		step_container.answer_spinbox.value = step.correct_answer() # TODO: remove in final version

		i += 1


func on_task_list_item_selected(task_list: ItemList, index: int) -> void:
	var task_name := task_list.get_item_text(index)
	var task := Tasks.all_tasks[task_name]

	task_environment.set_current_task(task)

	Global.clear_grid(task_data_grid)

	var values := task_environment.task.values()
	for value_name in values:
		var value_value: TaskFloatValue = values[value_name]

		var label := Label.new()
		label.text = value_name
		task_data_grid.add_child(label)

		var a := func(value: float) -> void: value_value.value = value

		var spin_box := SpinBox.new()
		spin_box.step = 1.0 / 10.0 ** value_value.precision_digits
		spin_box.min_value = spin_box.step
		spin_box.max_value = 10.0
		spin_box.value = value_value.value
		spin_box.value_changed.connect(a)
		task_data_grid.add_child(spin_box)

	set_step_ui()


func _on_task_filter_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		fill_task_lists()
		return

	var task_name_contains_filter_text := func(task_name: String) -> bool:
		return task_name.to_lower().contains(new_text.to_lower())

	fill_task_lists_if(task_name_contains_filter_text)


func _on_easy_task_list_item_selected(index: int) -> void:
	on_task_list_item_selected(easy_task_list, index)
	medium_task_list.deselect_all()
	hard_task_list.deselect_all()


func _on_medium_task_list_item_selected(index: int) -> void:
	on_task_list_item_selected(medium_task_list, index)
	easy_task_list.deselect_all()
	hard_task_list.deselect_all()


func _on_hard_task_list_item_selected(index: int) -> void:
	on_task_list_item_selected(hard_task_list, index)
	easy_task_list.deselect_all()
	medium_task_list.deselect_all()
