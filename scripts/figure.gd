@abstract class_name Figure
extends MeshInstance3D

signal properties_changed

var vertex_meshes: Array[MeshInstance3D]
var edge_meshes: Array[MeshInstance3D]


func _ready() -> void:
	var vertices := scaled_vertices()

	for vertex_position in vertices:
		var vertex_mesh: SphereMesh = preload("res://assets/vertex_mesh.tres")
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = vertex_mesh
		mesh_instance.position = vertex_position

		vertex_meshes.push_back(mesh_instance)
		add_child(mesh_instance)

	for edge in edges():
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_mesh: CylinderMesh = preload("res://assets/edge_mesh.tres").duplicate()
		edge_mesh.height = start_vertex.distance_to(end_vertex)
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = edge_mesh
		mesh_instance.position = midpoint

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		var basis1 := Basis(basis_right, basis_up, basis_forward)
		mesh_instance.transform = Transform3D(basis1, midpoint)

		edge_meshes.push_back(mesh_instance)
		add_child(mesh_instance)


	connect_signals()


func connect_signals() -> void:
	properties_changed.connect(set_vertices)
	properties_changed.connect(set_edges)


func set_vertices() -> void:
	var vertices := scaled_vertices()
	for i in range(vertex_meshes.size()):
		var vertex_position := vertices[i]
		var vertex_mesh := vertex_meshes[i]
		vertex_mesh.position = vertex_position


func set_edges() -> void:
	var vertices := scaled_vertices()
	var edges := edges()
	for i in range(edge_meshes.size()):
		var edge := edges[i]
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_mesh: CylinderMesh = edge_meshes[i].mesh
		edge_mesh.height = start_vertex.distance_to(end_vertex)
		edge_meshes[i].position = midpoint

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		var basis1 := Basis(basis_right, basis_up, basis_forward)
		edge_meshes[i].transform = Transform3D(basis1, midpoint)


# TODO:remove because unused?
@abstract func vertices() -> Array[Vector3]


@abstract func scaled_vertices() -> Array[Vector3]


@abstract func edges() -> Array[Edge]


@abstract func area() -> float


@abstract func volume() -> float

