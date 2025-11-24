class_name ShapeWorld
extends WorldEnvironment

var current_task: Task

@onready var camera: Camera3D = $Camera
@onready var raycast: RayCast3D = $Camera/RayCast
@onready var viewport: SubViewport = get_parent()


# TODO: better screen management, SceneTree set_current_scene?
func _process(_delta: float) -> void:
	var viewport_size := viewport.size
	var mouse_pos := viewport.get_mouse_position()
	var mouse_in_viewport := mouse_pos.x >= 0.0 and mouse_pos.x <= viewport_size.x and mouse_pos.y >= 0.0 and mouse_pos.y <= viewport_size.y

	raycast.target_position = 10.0 * camera.project_local_ray_normal(mouse_pos)
	raycast.enabled = mouse_in_viewport


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
