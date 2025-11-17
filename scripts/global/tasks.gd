extends Node

const SCENE_DIRECTORY: String = "res://scenes/tasks/"

var all_tasks: Dictionary[String, Task]


func _ready() -> void:
	load_all_tasks()


func load_all_tasks() -> void:
	var task_paths := ResourceLoader.list_directory(Tasks.SCENE_DIRECTORY)
	for path in task_paths:
		if path.ends_with(".tscn"):
			var task_scene: PackedScene = load(Tasks.SCENE_DIRECTORY.path_join(path))
			var task: Task = task_scene.instantiate()
			all_tasks[niceify_name(task.name)] = task

			# this is to properly instantiate and call _ready on all subnodes of task
			# if task is not added as child, subnodes are not initialized
			add_child(task)
			remove_child(task)


func niceify_name(task_name: String) -> String:
	return task_name.replace("Task", "").capitalize()


func deniceify_name(task_name: String) -> String:
	return task_name.replace(" ", "") + "Task"
