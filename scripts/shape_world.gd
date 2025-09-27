class_name ShapeWorld
extends WorldEnvironment

var current_task: Task

# TODO: move to own directory and load all from it
const ALL_TASKS: Array[NodePath] = [
	"res://scenes/cube_task.tscn",
	"res://scenes/prism_task.tscn",
]

func spawn_new_task() -> void:
	var random_task_index := randi_range(0, ALL_TASKS.size() - 1)
	
	var task_scene: PackedScene = load(ALL_TASKS[random_task_index])

	var task: Task = task_scene.instantiate()
	task.randomize_values()

	if current_task != null:
		current_task.queue_free()
	
	add_child(task)
	current_task = task
