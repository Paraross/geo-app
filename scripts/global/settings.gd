extends Node

const CONFIG_FILE_PATH: String = "user://settings.cfg"
const SETTINGS_SECTION: String = "settings"

const DATA_PRECISION_STR: String = "data_precision"
const ANSWER_PRECISION_STR: String = "answer_precision"

var settings: Dictionary[String, Setting] = {
	DATA_PRECISION_STR: IntSetting.new(1, 0, 6, "", "digits"),
	ANSWER_PRECISION_STR: IntSetting.new(2, 0, 6, "", "digits"),
}

var data_precision: int:
	get:
		return settings[DATA_PRECISION_STR].value
	set(value):
		settings[DATA_PRECISION_STR].set_value(value)

var answer_precision: int:
	get:
		return settings[ANSWER_PRECISION_STR].value
	set(value):
		settings[ANSWER_PRECISION_STR].set_value(value)


func _ready() -> void:
	load_settings_from_file()


func load_settings_from_file() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_FILE_PATH)

	if err == Error.ERR_FILE_NOT_FOUND:
		save_settings_to_file()
		return

	if err != OK:
		print("error opening settings file: %s" % err)
		return

	for setting_name in settings:
		var has_key := config.has_section_key(SETTINGS_SECTION, setting_name)
		if has_key:
			settings[setting_name].set_value_no_change(config.get_value(SETTINGS_SECTION, setting_name))


func save_settings_to_file() -> void:
	var config := ConfigFile.new()
	for setting_name in settings:
		config.set_value(SETTINGS_SECTION, setting_name, settings[setting_name].value)
	config.save(CONFIG_FILE_PATH)


func set_all_original_values() -> void:
	for setting_name in settings:
		settings[setting_name].set_original_value()


func reset_all_to_original() -> void:
	for setting_name in settings:
		settings[setting_name].reset_to_original()
