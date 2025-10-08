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


func niceify_name(task_name: String) -> String:
	return task_name.replace("Task", "").capitalize()


func deniceify_name(task_name: String) -> String:
	return task_name.replace(" ", "") + "Task"


class TaskFloatValue:
	var min_value: float
	var max_value: float
	var value: float

	static func default() -> TaskFloatValue:
		return TaskFloatValue.new(
			Settings.default_task_data_min_value,
			Settings.default_task_data_max_value,
		)


	func _init(min_value: float, max_value: float, value: float = 0.0) -> void:
		self.min_value = min_value
		self.max_value = max_value
		self.value = value
	

	func random_in_range() -> float:
		return randf_range(self.min_value, self.max_value)
	

	func randomize_and_round() -> void:
		self.value = Global.round_task_data(self.random_in_range())
