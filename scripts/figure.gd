@abstract class_name Figure
extends MeshInstance3D

signal properties_changed

var vertex_meshes: Array[MeshInstance3D]


func _ready() -> void:
	for vertex_position: Vector3 in vertices():
		var vertex_mesh: SphereMesh = preload("res://assets/vertex_mesh.tres")
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = vertex_mesh
		mesh_instance.position = vertex_position
		vertex_meshes.push_back(mesh_instance)
		add_child(mesh_instance)

	connect_signals()


func connect_signals() -> void:
	properties_changed.connect(set_vertices)


func set_vertices() -> void:
	var vertices := scaled_vertices()
	for i in range(vertex_meshes.size()):
		var vertex_position := vertices[i]
		var vertex_mesh := vertex_meshes[i]
		vertex_mesh.position = vertex_position


@abstract func vertices() -> Array[Vector3]


@abstract func scaled_vertices() -> Array[Vector3]


@abstract func area() -> float


@abstract func volume() -> float

