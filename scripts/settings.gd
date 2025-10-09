extends Node

const config_file_path: String = "user://settings.cfg"
const settings_section: String = "settings"

# TODO: This should probably just be a Dictionary
var data_precision: int = 1
var answer_precision: int = 2

var default_task_data_min_value: float = 1.0
var default_task_data_max_value: float = 2.0

func _ready() -> void:
	load_settings_from_file()


func load_settings_from_file() -> void:
	var config := ConfigFile.new()
	var err := config.load(config_file_path)

	if err == Error.ERR_FILE_NOT_FOUND:
		save_settings_to_file()
		return

	if err != OK:
		print("error opening settings file: %s" % err)
		return

	data_precision = config.get_value(settings_section, "data_precision")
	answer_precision = config.get_value(settings_section, "answer_precision")


func save_settings_to_file() -> void:
	var config := ConfigFile.new()
	config.set_value(settings_section, "data_precision", data_precision)
	config.set_value(settings_section, "answer_precision", answer_precision)
	config.save(config_file_path)
