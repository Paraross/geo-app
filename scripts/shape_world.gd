class_name ShapeWorld
extends WorldEnvironment

const TASK_SCENE_DIRECTORY: String = "res://scenes/tasks/"

var current_task: Task

var all_task_paths: PackedStringArray = []

func _ready() -> void:
	var task_paths := ResourceLoader.list_directory(TASK_SCENE_DIRECTORY)
	for path in task_paths:
		if path.ends_with(".tscn"):
			all_task_paths.push_back(path)


func spawn_new_task() -> void:
	var random_task_index := randi_range(0, all_task_paths.size() - 1)

	var task_path := TASK_SCENE_DIRECTORY.path_join(all_task_paths[random_task_index])
	var task_scene: PackedScene = load(task_path)

	var task: Task = task_scene.instantiate()
	task.randomize_values()

	if current_task != null:
		current_task.queue_free()
	
	add_child(task)
	current_task = task
