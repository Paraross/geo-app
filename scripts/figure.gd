@abstract class_name Figure
extends Area3D

@warning_ignore("unused_signal")
signal properties_changed
signal hover_started
signal hover_ended
signal clicked

@export var hl_material: Material = preload("res://assets/highlight_material.tres")

var was_hovered: bool = false
var is_hovered: bool = false

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _process(_delta: float) -> void:
	if not was_hovered and is_hovered:
		on_hover_start()
	elif was_hovered and not is_hovered:
		on_hover_end()

	if is_hovered:
		if Input.is_action_just_pressed("select_figure"):
			clicked.emit()

	was_hovered = is_hovered
	is_hovered = false


func on_hover_start() -> void:
	mesh_instance.set_surface_override_material(0, hl_material)
	hover_started.emit()


func on_hover_end() -> void:
	mesh_instance.set_surface_override_material(0, null)
	hover_ended.emit()


@abstract func area() -> float


@abstract func volume() -> float
