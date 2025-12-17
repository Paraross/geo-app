class_name LabelComponent
extends Label3D

# TODO: label nie resetowany przy przechodzeniu formulas <-> tasks

@onready var figure: Figure = get_parent()


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	# HACK: call_deferred makes sure that label gets updated after vertices and edges
	# otherwise the position may lag behind
	# should be implemented such that it's not needed
	figure.properties_changed.connect(update_label.call_deferred)
	figure.clicked.connect(toggle_visibility)


func update_label() -> void:
	if figure is Cylinder:
		var cylinder: Cylinder = figure
		text = "Length:\n%s" % Global.round_task_data(cylinder.height)


func toggle_visibility() -> void:
	visible = !visible
