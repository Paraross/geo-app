class_name PlaygroundScreen
extends Screen

const SHAPE_OPTIONS: Array[String] = [
	"Cube",
	"Prism",
	"Pyramid",
]

const SHAPE_VERTICES: Array[PackedVector3Array] = [
	CUBE_VERTICES,
	PRISM_VERTICES,
	PYRAMID_VERTICES,
]

const CUBE_VERTICES: PackedVector3Array = [
	Vector3(-1, 1, 1),
	Vector3(1, 1, 1),
	Vector3(1, -1, 1),
	Vector3(-1, -1, 1),
	Vector3(-1, 1, -1),
	Vector3(1, 1, -1),
	Vector3(1, -1, -1),
	Vector3(-1, -1, -1),
]

const PRISM_VERTICES: PackedVector3Array = [
	Vector3(-1, -1, 1),
	Vector3(1, -1, 1),
	Vector3(0, 1, 1),
	Vector3(-1, -1, -1),
	Vector3(1, -1, -1),
	Vector3(0, 1, -1),
]

const PYRAMID_VERTICES: PackedVector3Array = [
	Vector3(0, 1, 0),
	Vector3(-1, -1, 1),
	Vector3(1, -1, 1),
	Vector3(1, -1, -1),
	Vector3(-1, -1, -1),
]

var vertex_ui_elements: Array[VertexUiElement] = []

@onready var polyhedron_environment: PolyhedronEnvironment = $HBoxContainer/ShapeViewportContainer/ShapeViewport/PolyhedronEnvironment

@onready var shape_button: OptionButton = $HBoxContainer/RightPanel/RightVBox/PredefinedHBox/ShapeButton

@onready var right_vbox: VBoxContainer = $HBoxContainer/RightPanel/RightVBox
@onready var vertices_vbox: VBoxContainer = right_vbox.get_node("ScrollContainer/VBox/VerticesVBox")
@onready var new_vertex_button: Button = right_vbox.get_node("NewVertexButton")

@onready var popup: PopupPanel = $Popup


func _ready() -> void:
	for shape in SHAPE_OPTIONS:
		shape_button.add_item(shape)
	shape_button.selected = 0


func on_entered() -> void:
	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()


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
	var vertices := PackedVector3Array()
	vertices.resize(vertex_ui_elements.size())

	for i in range(vertex_ui_elements.size()):
		var element := vertex_ui_elements[i]
		var x := element.x_spinbox.value
		var y := element.y_spinbox.value
		var z := element.z_spinbox.value
		vertices[i] = Vector3(x, y, z)

	if not Poly.are_valid_polyhedron_vertices(vertices):
		popup.show()
		return

	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertices = vertices
	polyhedron.update_vertices()


func _on_load_button_pressed() -> void:
	var vertices := SHAPE_VERTICES[shape_button.selected]
	print(vertices)

	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()

	for v in vertices:
		var new_vertex_ui_element := add_new_vertex_ui_element()
		new_vertex_ui_element.x_spinbox.value = v.x
		new_vertex_ui_element.y_spinbox.value = v.y
		new_vertex_ui_element.z_spinbox.value = v.z
