class_name FormulasScreen
extends Screen

@onready var task_filter_edit: LineEdit = $CenterContainer/PanelContainer/HBox/TaskVBox/TaskFilterEdit
@onready var task_list: ItemList = $CenterContainer/PanelContainer/HBox/TaskVBox/TaskList

func on_entered() -> void:
	task_filter_edit.text = ""
	fill_task_list()


func on_left() -> void:
	pass


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
	print(task)
