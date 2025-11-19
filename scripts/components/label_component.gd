class_name LabelComponent
extends Node

@export var vertex1_index: int
@export var vertex2_index: int

@onready var label: Label3D = $Label
@onready var figure: Figure = get_parent()


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	figure.properties_changed.connect(update_label)


func update_label() -> void:
	var vertices := figure.scaled_vertices()

	var vertex1 := vertices[vertex1_index]
	var vertex2 := vertices[vertex2_index]
	var midpoint := (vertex1 + vertex2) / 2.0
	var length := vertex1.distance_to(vertex2)

	var from_to := (vertex2 - vertex1).normalized()
	var up := Vector3.UP
	var right := from_to.cross(up)

	label.position = midpoint + right * 0.2
	label.text = "Length:\n%s" % Global.round_task_data(length)
