class_name PlaygroundScreen
extends Screen

const VERTICES: PackedVector3Array = [
	# front
	Vector3(-1, 1, 1), # 1 left top near
	Vector3(1, 1, 1), # 2 right top near
	Vector3(1, -1, 1), # 6 right bottom near
	Vector3(-1, -1, 1), # 5 left bottom near
	# back
	Vector3(-1, 1, -1), # 0 left top far
	Vector3(1, 1, -1), # 3 right top far
	Vector3(1, -1, -1), # 7 right bottom far
	Vector3(-1, -1, -1), # 4 left bottom far
]

var vertex_ui_elements: Array[VertexUiElement] = []

@onready var polyhedron_environment: PolyhedronEnvironment = $HBoxContainer/ShapeViewportContainer/ShapeViewport/PolyhedronEnvironment

@onready var right_vbox: VBoxContainer = $HBoxContainer/RightPanel/RightVBox
@onready var vertices_vbox: VBoxContainer = right_vbox.get_node("ScrollContainer/VBox/VerticesVBox")
@onready var new_vertex_button: Button = right_vbox.get_node("ScrollContainer/VBox/NewVertexButton")


func on_entered() -> void:
	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()

	for v in VERTICES:
		var new_vertex_ui_element := add_new_vertex_ui_element()
		new_vertex_ui_element.x_spinbox.value = v.x
		new_vertex_ui_element.y_spinbox.value = v.y
		new_vertex_ui_element.z_spinbox.value = v.z


func on_left() -> void:
	reset()


func reset() -> void:
	polyhedron_environment.unload_polyhedron()


func add_new_vertex_ui_element() -> VertexUiElement:
	var vertex_ui_element: VertexUiElement = preload("res://scenes/vertex_ui_element.tscn").instantiate()

	vertex_ui_elements.append(vertex_ui_element)
	vertices_vbox.add_child(vertex_ui_element)

	vertex_ui_element.remove_button.pressed.connect(
		func() -> void:
			remove_vertex_ui_element(vertex_ui_element)
	)

	vertex_ui_element.label.text = "Vertex %s" % vertex_ui_elements.size()

	return vertex_ui_element


func remove_vertex_ui_element(element: VertexUiElement) -> void:
	element.queue_free()
	# remove_child(element)
	vertex_ui_elements.erase(element)


func _on_new_vertex_button_pressed() -> void:
	add_new_vertex_ui_element()


func _on_create_polyhedron_button_pressed() -> void:
	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertices.resize(vertex_ui_elements.size())

	var i := 0
	for vertex_ui_element in vertex_ui_elements:
		var x := vertex_ui_element.x_spinbox.value
		var y := vertex_ui_element.y_spinbox.value
		var z := vertex_ui_element.z_spinbox.value
		var vertex := Vector3(x, y, z)
		polyhedron.vertices[i] = vertex
		i += 1

	polyhedron.update_vertices()
