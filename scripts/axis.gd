@tool
extends MeshInstance3D

@export var material: Material
@export var sphere_radius: float = 0.05
@export var label_distance: float = 0.2

@export var start_pos: float = -10.0
@export var end_pos: float = 10.0
@export var step: float = 1.0


func _ready() -> void:
	# NOTE: can be optimized
	var sphere_mesh_scene: PackedScene = preload("res://scenes/axis_sphere.tscn").duplicate_deep()

	var pos := start_pos
	while pos <= end_pos:
		if pos == 0.0:
			pos += step
			continue

		var sphere_mesh_instance: MeshInstance3D = sphere_mesh_scene.instantiate()
		var sphere_mesh: SphereMesh = sphere_mesh_instance.mesh
		sphere_mesh.material = material
		sphere_mesh_instance.position = Vector3(0.0, pos, 0.0)
		add_child(sphere_mesh_instance)

		var label := Label3D.new()
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.position = Vector3(label_distance, 0.0, 0.0)
		label.text = "%s" % pos
		sphere_mesh_instance.add_child(label)

		pos += step

	var m := mesh as CylinderMesh
	m.material = material
