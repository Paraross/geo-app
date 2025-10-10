extends Node

const config_file_path: String = "user://settings.cfg"
const settings_section: String = "settings"

const data_precision_str: String = "data_precision"
const answer_precision_str: String = "answer_precision"

var settings: Dictionary[String, Setting] = {
	data_precision_str: IntSetting.new(1, 0, 6, "", "digits"),
	answer_precision_str: IntSetting.new(2, 0, 6, "", "digits"),
}

var data_precision: int:
	get: return settings[data_precision_str].value
	set(value): settings[data_precision_str].set_value(value)

var answer_precision: int:
	get: return settings[answer_precision_str].value
	set(value): settings[answer_precision_str].set_value(value)

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
		var has_key := config.has_section_key(settings_section, setting_name)
		if has_key:
			settings[setting_name].set_value_no_change(config.get_value(settings_section, setting_name))


func save_settings_to_file() -> void:
	var config := ConfigFile.new()
	for setting_name in settings:
		config.set_value(settings_section, setting_name, settings[setting_name].value)
	config.save(config_file_path)
