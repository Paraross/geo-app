class_name AnimationComponent
extends Node

# https://youtu.be/jF3UgstQ1Yk

@export var trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var scale_value: Vector2 = Vector2(1.0, 1.0)
@export var duration: float = 1.0
@export var from_center: bool = true

@onready var node: Control = get_parent()
@onready var default_scale: Vector2


func _ready() -> void:
	connect_signals()

	setup.call_deferred()


func connect_signals() -> void:
	node.focus_entered.connect(on_hover_start)
	node.focus_exited.connect(on_hover_end)


func on_hover_start() -> void:
	add_tween("scale", scale_value)


func on_hover_end() -> void:
	add_tween("scale", default_scale)


func add_tween(property: String, value: Variant) -> void:
	var tween := node.create_tween().set_trans(trans_type).set_ease(ease_type)
	tween.tween_property(node, property, value, duration)


func setup() -> void:
	if from_center:
		node.pivot_offset = node.size / 2.0
	default_scale = node.scale
