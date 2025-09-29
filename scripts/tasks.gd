extends Node

const SCENE_DIRECTORY: String = "res://scenes/tasks/"

var all_tasks: Array[Task]

func _ready() -> void:
	load_all_tasks()


func load_all_tasks() -> void:
	var task_paths := ResourceLoader.list_directory(Tasks.SCENE_DIRECTORY)
	for path in task_paths:
		if path.ends_with(".tscn"):
			var task_scene: PackedScene = load(Tasks.SCENE_DIRECTORY.path_join(path))
			var task: Task = task_scene.instantiate()
			all_tasks.push_back(task)


func niceify_name(task_name: String) -> String:
	return task_name.replace("Task", "").capitalize()


func deniceify_name(task_name: String) -> String:
	return task_name.replace(" ", "") + "Task"
