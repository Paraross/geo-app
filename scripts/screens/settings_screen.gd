class_name SettingsScreen
extends Screen

func on_entered() -> void:
	pass


func on_left() -> void:
	pass


func _on_data_precision_changed(value: float) -> void:
	Settings.data_precision = int(value)


func _on_answer_precision_changed(value: float) -> void:
	Settings.answer_precision = int(value)
