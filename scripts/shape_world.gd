class_name ShapeWorld
extends WorldEnvironment

var current_task: Task

func spawn_new_task() -> void:
	var random_task_index := randi_range(0, Tasks.all_tasks.size() - 1)

	var task := Tasks.all_tasks[random_task_index]
	task.randomize_values()

	if current_task != null:
		remove_child(current_task)
	
	add_child(task)
	current_task = task
