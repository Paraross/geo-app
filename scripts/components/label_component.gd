class_name LabelComponent
extends Label3D

# TODO: label nie resetowany przy przechodzeniu formulas <-> tasks

@onready var figure: Figure = get_parent()


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	figure.label_visibility_requested.connect(set_visible)
	figure.clicked.connect(toggle_visibility)


func make_invisible() -> void:
	visible = false


func toggle_visibility() -> void:
	visible = !visible
