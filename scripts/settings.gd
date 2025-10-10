extends Node

const config_file_path: String = "user://settings.cfg"
const settings_section: String = "settings"

var settings: Dictionary[String, Variant] = {
	"data_precision": 1,
	"answer_precision": 2,
}

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

	for setting_name in settings:
		settings[setting_name] = config.get_value(settings_section, setting_name)


func save_settings_to_file() -> void:
	var config := ConfigFile.new()
	for setting_name in settings:
		config.set_value(settings_section, setting_name, settings[setting_name])
	config.save(config_file_path)


func data_precision() -> int:
	return settings["data_precision"]


func answer_precision() -> int:
	return settings["answer_precision"]
