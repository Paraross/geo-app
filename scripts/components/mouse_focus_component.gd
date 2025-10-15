class_name MouseFocusComponent
extends Node

@onready var node: Control = get_parent()

func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	node.mouse_entered.connect(on_entered)
	node.mouse_exited.connect(on_exited)


func on_entered() -> void:
	node.grab_focus.call_deferred()


func on_exited() -> void:
	node.release_focus()
