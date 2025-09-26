extends Camera3D

#TODO: improve input handling when inputting answers
#TODO: e.g ctrl+a both rotates the camera and selects in the spin box

## In radians per second.
@export var rotation_speed: float = TAU / 3.0
@export var zoom_speed: float = 1.0

func _ready() -> void:
	look_at(Vector3.ZERO)


func _process(delta: float) -> void:
	rotate_camera(delta)
	zoom_camera(delta)
	look_at(Vector3.ZERO)


func rotate_camera(delta: float) -> void:
	var rotate_amount := rotation_speed * delta
	var camera_angle := -asin(position.y / position.length())
	
	var next_camera_position := position
	if Input.is_action_pressed("camera_up") and camera_angle - rotate_amount > -PI / 2.0:
		var left := -Vector3.UP.cross(position).normalized()
		next_camera_position += position.rotated(left, rotate_amount) - position
	if Input.is_action_pressed("camera_down") and camera_angle + rotate_amount < PI / 2.0:
		var right := Vector3.UP.cross(position).normalized()
		next_camera_position += position.rotated(right, rotate_amount) - position
	if Input.is_action_pressed("camera_left"):
		next_camera_position += position.rotated(Vector3.DOWN, rotate_amount) - position
	if Input.is_action_pressed("camera_right"):
		next_camera_position += position.rotated(Vector3.UP, rotate_amount) - position
		
	position = next_camera_position


func zoom_camera(delta: float) -> void:
	var zoom_amount := zoom_speed * delta

	if Input.is_action_pressed("camera_in"):
		position -= position * zoom_amount
	if Input.is_action_pressed("camera_out"):
		position += position * zoom_amount
