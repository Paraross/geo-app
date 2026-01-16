extends Node

const CONFIG_FILE_PATH: String = "user://settings.cfg"
const SETTINGS_SECTION: String = "settings"

const CAMERA_MOVE_SPEED: String = "Move speed"
const CAMERA_ZOOM_SPEED: String = "Zoom speed"
const COORDINATE_PRECISION: String = "Coordinate precision"

var settings: Dictionary[String, Setting] = {
	CAMERA_MOVE_SPEED: FloatSetting.new("Camera", 120.0, 1.0, 360.0, 1.0, "", "In degrees per second"),
	CAMERA_ZOOM_SPEED: FloatSetting.new("Camera", 5.0, 0.1, 10.0, 0.1, "", "In units per second"),
	COORDINATE_PRECISION: IntSetting.new("Playground", 0, 0, 6, "digits", "How many digits of precision should the vertices allow"),
}

var camera_move_speed: float:
	get:
		return settings[CAMERA_MOVE_SPEED].value
	set(value):
		settings[CAMERA_MOVE_SPEED].set_value(value)

var camera_zoom_speed: float:
	get:
		return settings[CAMERA_ZOOM_SPEED].value
	set(value):
		settings[CAMERA_ZOOM_SPEED].set_value(value)

var coordinate_precision: int:
	get:
		return settings[COORDINATE_PRECISION].value
	set(value):
		settings[COORDINATE_PRECISION].set_value(value)


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
