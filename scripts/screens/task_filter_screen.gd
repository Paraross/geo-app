class_name TaskFilterScreen
extends Screen

@onready var task_filter_vbox: VBoxContainer = $CenterContainer/PanelContainer/VBoxContainer
@onready var difficulty_list: ItemList = task_filter_vbox.get_node("GridContainer/DifficultyList")
@onready var task_list: ItemList = task_filter_vbox.get_node("GridContainer/TaskList")
@onready var task_settings_popup: PopupPanel = $TaskSettingsPopup
@onready var task_settings_popup_vbox: VBoxContainer = task_settings_popup.get_node("VBox")
@onready var task_settings_popup_label: Label = task_settings_popup_vbox.get_node("Label")
@onready var task_settings_popup_grid: GridContainer = task_settings_popup_vbox.get_node("TaskValueGrid")
@onready var start_button: Button = task_filter_vbox.get_node("StartButton")

func on_entered() -> void:
	pass


func on_left() -> void:
	pass


func _ready() -> void:
	initialize_difficulty_list()


func initialize_difficulty_list() -> void:
	for difficulty_name: String in Global.TaskDifficulty.keys():
		difficulty_list.add_item(difficulty_name.capitalize())

	# select all by default
	for i in range(difficulty_list.item_count):
		difficulty_list.select(i, false)

	fill_task_list()


func fill_task_list() -> void:
	var selected_difficulty_indices := difficulty_list.get_selected_items()

	task_list.clear()
	for task_name in Tasks.all_tasks:
		var task := Tasks.all_tasks[task_name]
		var task_difficulty_is_selected := selected_difficulty_indices.find(task.difficulty()) != -1
		if task_difficulty_is_selected:
			task_list.add_item(task_name)


func selected_task() -> Task:
	var selected_task_indices := task_list.get_selected_items()

	var nice_name := task_list.get_item_text(selected_task_indices[0])
	var selected_task := Tasks.all_tasks[nice_name]

	return selected_task


func _on_difficulty_item_list_multi_selected(_index: int, _selected: bool) -> void:
	start_button.disabled = true
	fill_task_list()


func _on_task_list_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index != MouseButton.MOUSE_BUTTON_RIGHT:
		return

	var task_name := task_list.get_item_text(index)
	var task := Tasks.all_tasks[task_name]

	task_settings_popup_label.text = "%s settings" % task_name

	Global.clear_grid(task_settings_popup_grid)

	var values := task.values()
	for value_name in values:
		var value_value: TaskFloatValue = values[value_name]

		var label := Label.new()
		label.text = value_name
		task_settings_popup_grid.add_child(label)

		var min_spin_box := SpinBox.new()
		min_spin_box.step = 1.0 / 10.0 ** Settings.data_precision
		min_spin_box.value = value_value.min_value
		min_spin_box.value_changed.connect(func(value: float) -> void: value_value.min_value = value)
		task_settings_popup_grid.add_child(min_spin_box)

		var max_spin_box := SpinBox.new()
		max_spin_box.step = 1.0 / 10.0 ** Settings.data_precision
		max_spin_box.value = value_value.max_value
		max_spin_box.value_changed.connect(func(value: float) -> void: value_value.max_value = value)
		task_settings_popup_grid.add_child(max_spin_box)

	task_settings_popup.show()


func _on_task_list_item_selected(_index: int) -> void:
	start_button.disabled = false


func _on_task_list_resized() -> void:
	# disable auto-resizing after size is set for the first time
	if task_list.size.x != 0.0 and task_list.size.y != 0.0:
		task_list.custom_minimum_size = task_list.size
		task_list.auto_width = false
		task_list.auto_height = false
