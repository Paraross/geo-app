class_name LabelComponent
extends Node

@onready var label: Label3D = $Label
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
	label.position = figure.position + 0.25 * figure.transform.basis.x
	if figure is Cyllinder:
		var cylinder: Cyllinder = figure
		label.text = "Length:\n%s" % Global.round_task_data(cylinder.height)


func toggle_visibility() -> void:
	label.visible = !label.visible
