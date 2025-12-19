class_name FigureEnvironment
extends WorldEnvironment

# TODO:
# axes on toggle
# free camera movement
# visual point around which camera rotates
# camera perspective / ortographic

@onready var camera: Camera3D = $Camera
@onready var raycast: RayCast3D = $Camera/RayCast
@onready var viewport: SubViewport = get_parent()


func _process(_delta: float) -> void:
	var viewport_size := viewport.size
	var mouse_pos := viewport.get_mouse_position()
	var mouse_in_viewport := mouse_pos.x >= 0.0 and mouse_pos.x <= viewport_size.x and mouse_pos.y >= 0.0 and mouse_pos.y <= viewport_size.y

	raycast.target_position = 10.0 * camera.project_local_ray_normal(mouse_pos)
	raycast.enabled = mouse_in_viewport

	if raycast.is_colliding():
		var collider: Figure = raycast.get_collider()
		collider.is_hovered = true
