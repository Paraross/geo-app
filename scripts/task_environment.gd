class_name TaskEnvironment
extends FigureEnvironment

var task: Task


func spawn_new_task(task: Task) -> void:
	task.randomize_values()
	set_current_task(task)


func set_current_task(t: Task) -> void:
	unload_current_task()
	add_child(t)
	task = t


func unload_current_task() -> void:
	if task != null:
		remove_child(task)
		task = null
