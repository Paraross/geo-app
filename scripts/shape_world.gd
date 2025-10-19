class_name ShapeWorld
extends WorldEnvironment

var current_task: Task

func spawn_new_task(available_tasks: Array[Task]) -> void:
	var random_task_index := randi_range(0, available_tasks.size() - 1)

	var task := available_tasks[random_task_index]
	task.randomize_values()

	set_current_task(task)


func set_current_task(task: Task) -> void:
	reset_current_task()
	add_child(task)
	current_task = task


func reset_current_task() -> void:
	if current_task != null:
		remove_child(current_task)
		current_task = null
