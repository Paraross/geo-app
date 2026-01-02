extends Camera3D

## In radians per second.
@export var rotation_speed: float = TAU / 3.0
@export var zoom_speed: float = 2.0

var move_up: bool = false
var move_down: bool = false
var move_left: bool = false
var move_right: bool = false
var zoom_in: bool = false
var zoom_out: bool = false


func _ready() -> void:
	look_at(Vector3.ZERO)


func _process(delta: float) -> void:
	rotate_camera(delta)
	zoom_camera(delta)
	look_at(Vector3.ZERO)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_up"):
		move_up = true
	elif event.is_action_released("camera_up"):
		move_up = false

	if event.is_action_pressed("camera_down"):
		move_down = true
	elif event.is_action_released("camera_down"):
		move_down = false

	if event.is_action_pressed("camera_left"):
		move_left = true
	elif event.is_action_released("camera_left"):
		move_left = false

	if event.is_action_pressed("camera_right"):
		move_right = true
	elif event.is_action_released("camera_right"):
		move_right = false

	if event.is_action_pressed("camera_in"):
		zoom_in = true
	elif event.is_action_released("camera_in"):
		zoom_in = false

	if event.is_action_pressed("camera_out"):
		zoom_out = true
	elif event.is_action_released("camera_out"):
		zoom_out = false


func rotate_camera(delta: float) -> void:
	var rotate_amount := rotation_speed * delta
	var camera_angle := -asin(position.y / position.length())

	if move_up and camera_angle - rotate_amount > -PI / 2.0:
		var left := Vector3.DOWN.cross(position).normalized()
		position = position.rotated(left, rotate_amount)
	if move_down and camera_angle + rotate_amount < PI / 2.0:
		var right := Vector3.UP.cross(position).normalized()
		position = position.rotated(right, rotate_amount)
	if move_left:
		position = position.rotated(Vector3.DOWN, rotate_amount)
	if move_right:
		position = position.rotated(Vector3.UP, rotate_amount)


func zoom_camera(delta: float) -> void:
	var zoom_amount := zoom_speed * delta

	var dir := position.normalized()

	if zoom_in:
		position = dir * (position.length() - zoom_amount)
	if zoom_out:
		position = dir * (position.length() + zoom_amount)
