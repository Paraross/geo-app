class_name FormulasScreen
extends Screen

@onready var task_filter_edit: LineEdit = $CenterContainer/PanelContainer/HBox/TaskFilterVBox/TaskFilterEdit
@onready var task_list: ItemList = $CenterContainer/PanelContainer/HBox/TaskFilterVBox/TaskList

@onready var area_tip_label: Label = $CenterContainer/PanelContainer/HBox/InfoVBox/AreaTipLabel
@onready var volume_tip_label: Label = $CenterContainer/PanelContainer/HBox/InfoVBox/VolumeTipLabel

@onready var shape_world: ShapeWorld = $CenterContainer/PanelContainer/HBox/TaskVBox/SubViewportContainer/SubViewport/ShapeWorld
@onready var task_data_grid: GridContainer = $CenterContainer/PanelContainer/HBox/TaskVBox/TaskDataGrid

func on_entered() -> void:
	task_filter_edit.text = ""
	fill_task_list()


func on_left() -> void:
	shape_world.reset_current_task()


func fill_task_list() -> void:
	task_list.clear()
	for task_name in Tasks.all_tasks:
		task_list.add_item(task_name)


func fill_task_list_if(condition: Callable) -> void:
	task_list.clear()
	for task_name in Tasks.all_tasks:
		var condition_met: bool = condition.call(task_name)
		if condition_met:
			task_list.add_item(task_name)


func _on_task_filter_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		fill_task_list()
		return

	var task_name_contains_filter_text := func (task_name: String) -> bool:
		return task_name.to_lower().contains(new_text.to_lower())

	fill_task_list_if(task_name_contains_filter_text)


func _on_task_list_item_selected(index: int) -> void:
	var task_name := task_list.get_item_text(index)
	var task := Tasks.all_tasks[task_name]

	area_tip_label.text = task.area_tip()
	volume_tip_label.text = task.volume_tip()

	shape_world.set_current_task(task)

	Global.clear_grid(task_data_grid)

	for task_value_pair: Array in shape_world.current_task.values():
		var value_name: String = task_value_pair[0]
		var value_value: TaskFloatValue = task_value_pair[1]

		var label := Label.new()
		label.text = value_name
		task_data_grid.add_child(label)

		var a := func (value: float) -> void: value_value.value = value

		var spin_box := SpinBox.new()
		spin_box.step = 1.0 / 10.0 ** Settings.data_precision
		spin_box.value = value_value.value
		spin_box.value_changed.connect(a)
		task_data_grid.add_child(spin_box)
