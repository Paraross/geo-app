class_name ShapeWorld
extends WorldEnvironment

var current_task: Task

func spawn_new_task() -> void:
	var task_scene: PackedScene = load("res://cube_task.tscn")
	var task: CubeTask = task_scene.instantiate()
	task.randomize_values()
	
	add_child(task)
	current_task = task
