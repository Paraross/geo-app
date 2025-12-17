class_name TaskEnvironment
extends FigureEnvironment

var task: Task


func spawn_new_task(available_tasks: Array[Task]) -> void:
	var random_task_index := randi_range(0, available_tasks.size() - 1)

	var task := available_tasks[random_task_index]
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
