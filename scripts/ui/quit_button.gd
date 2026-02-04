extends Button


func _on_quit_button_pressed() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
