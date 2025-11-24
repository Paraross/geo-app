@abstract class_name Figure
extends MeshInstance3D

signal properties_changed

var vertex_spheres: Array[Sphere]
var edge_cylinders: Array[Cyllinder]


func _ready() -> void:
	var vertices := scaled_vertices()
	var vertex_sphere_scene: PackedScene = preload("res://scenes/figures/sphere.tscn")
	var vertex_sphere_mesh: SphereMesh = preload("res://assets/vertex_mesh.tres")

	for vertex_position in vertices:
		var vertex_sphere: Sphere = vertex_sphere_scene.instantiate()
		vertex_sphere.mesh = vertex_sphere_mesh

		vertex_spheres.push_back(vertex_sphere)
		add_child(vertex_sphere)

		vertex_sphere.position = vertex_position
		vertex_sphere.radius = 0.05

	var edge_cylinder_scene: PackedScene = preload("res://scenes/figures/cylinder.tscn")
	var edge_cylinder_mesh: CylinderMesh = preload("res://assets/edge_mesh.tres")

	for edge in edges():
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_cylinder: Cyllinder = edge_cylinder_scene.instantiate()
		edge_cylinder.mesh = edge_cylinder_mesh.duplicate()

		edge_cylinders.push_back(edge_cylinder)
		add_child(edge_cylinder)

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		edge_cylinder.height = start_vertex.distance_to(end_vertex)
		edge_cylinder.radius = 0.025
		edge_cylinder.transform = Transform3D(Basis(basis_right, basis_up, basis_forward), midpoint)

	connect_signals()


func connect_signals() -> void:
	properties_changed.connect(set_vertices)
	properties_changed.connect(set_edges)


func set_vertices() -> void:
	var vertices := scaled_vertices()
	for i in range(vertex_spheres.size()):
		var vertex_position := vertices[i]
		var vertex_mesh := vertex_spheres[i]
		vertex_mesh.position = vertex_position


func set_edges() -> void:
	var vertices := scaled_vertices()
	var edges := edges()
	for i in range(edge_cylinders.size()):
		var edge := edges[i]
		var start_vertex := vertices[edge.start_index]
		var end_vertex := vertices[edge.end_index]
		var midpoint := (start_vertex + end_vertex) / 2.0

		var edge_mesh: CylinderMesh = edge_cylinders[i].mesh
		edge_mesh.height = start_vertex.distance_to(end_vertex)
		edge_cylinders[i].position = midpoint

		var basis_right := (midpoint - position).normalized()
		var basis_up := (end_vertex - start_vertex).normalized()
		var basis_forward := -basis_up.cross(basis_right)

		var basis1 := Basis(basis_right, basis_up, basis_forward)
		edge_cylinders[i].transform = Transform3D(basis1, midpoint)


# TODO:remove because unused?
@abstract func vertices() -> Array[Vector3]


@abstract func scaled_vertices() -> Array[Vector3]


@abstract func edges() -> Array[Edge]


@abstract func area() -> float


@abstract func volume() -> float
