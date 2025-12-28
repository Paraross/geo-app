class_name PlaygroundScreen
extends Screen

const SHAPE_OPTIONS: Array[String] = [
	"Cube",
	"Prism",
	"Pyramid",
]

const SHAPES_VERTICES: Array[PackedVector3Array] = [
	Poly.CUBE_VERTICES,
	Poly.PRISM_VERTICES,
	Poly.PYRAMID_VERTICES,
]

var vertex_ui_elements: Array[VertexUiElement] = []

var save_file_content: String

@onready var polyhedron_environment: PolyhedronEnvironment = $HBoxContainer/ShapeViewportContainer/ShapeViewport/PolyhedronEnvironment

@onready var shape_button: OptionButton = $HBoxContainer/RightPanel/RightVBox/PredefinedHBox/ShapeButton

@onready var right_vbox: VBoxContainer = $HBoxContainer/RightPanel/RightVBox
@onready var vertices_vbox: VBoxContainer = right_vbox.get_node("ScrollContainer/VBox/VerticesVBox")
@onready var new_vertex_button: Button = right_vbox.get_node("NewVertexButton")

@onready var popup: PopupPanel = $Popup

@onready var save_file_dialog: FileDialog = $SaveFileDialog
@onready var load_file_dialog: FileDialog = $LoadFileDialog


func _ready() -> void:
	for shape in SHAPE_OPTIONS:
		shape_button.add_item(shape)
	shape_button.selected = 0


func on_entered() -> void:
	clear_vertex_ui_elements()


func on_left() -> void:
	reset()


func reset() -> void:
	polyhedron_environment.unload_polyhedron()


func add_new_vertex_ui_element(x: float, y: float, z: float, vertex_name: String = "") -> VertexUiElement:
	var vertex_ui_element: VertexUiElement = preload("res://scenes/vertex_ui_element.tscn").instantiate()

	vertex_ui_elements.append(vertex_ui_element)
	vertices_vbox.add_child(vertex_ui_element)

	vertex_ui_element.remove_button.pressed.connect(
		func() -> void:
			remove_vertex_ui_element(vertex_ui_element)
	)

	vertex_ui_element.vertex_name = vertex_name if vertex_name != "" else "Vertex %s" % vertex_ui_elements.size()
	vertex_ui_element.x_spinbox.value = x
	vertex_ui_element.y_spinbox.value = y
	vertex_ui_element.z_spinbox.value = z

	return vertex_ui_element


func remove_vertex_ui_element(element: VertexUiElement) -> void:
	element.queue_free()
	vertex_ui_elements.erase(element)


func clear_vertex_ui_elements() -> void:
	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()


func create_polyhedron_from_vertices(vertices: PackedVector3Array) -> void:
	if not Poly.are_valid_polyhedron_vertices(vertices):
		popup.show()
		return

	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertices = vertices
	polyhedron.update_vertices()


func _on_new_vertex_button_pressed() -> void:
	add_new_vertex_ui_element(0.0, 0.0, 0.0)


func _on_create_polyhedron_button_pressed() -> void:
	var vertices := PackedVector3Array()
	vertices.resize(vertex_ui_elements.size())

	for i in range(vertex_ui_elements.size()):
		vertices[i] = vertex_ui_elements[i].get_vertex()

	create_polyhedron_from_vertices(vertices)


func _on_load_button_pressed() -> void:
	var vertices := SHAPES_VERTICES[shape_button.selected]

	clear_vertex_ui_elements()

	for v in vertices:
		add_new_vertex_ui_element(v.x, v.y, v.z)

	create_polyhedron_from_vertices(vertices)


func _on_from_file_button_pressed() -> void:
	load_file_dialog.show()


func _on_save_to_file_button_pressed() -> void:
	var vertices := PackedVector3Array()
	vertices.resize(vertex_ui_elements.size())

	var verts_for_json: Array[Dictionary] = []
	verts_for_json.resize(vertex_ui_elements.size())

	for i in range(vertex_ui_elements.size()):
		var element := vertex_ui_elements[i]
		var vertex := element.get_vertex()
		vertices[i] = Vector3(vertex.x, vertex.y, vertex.z)

		verts_for_json[i] = { "name": element.vertex_name, "x": vertex.x, "y": vertex.y, "z": vertex.z }

	var vertices_json := JSON.stringify(verts_for_json, "  ")

	save_file_content = vertices_json

	save_file_dialog.show()


func _on_save_file_dialog_file_selected(path: String) -> void:
	var save_file := FileAccess.open(path, FileAccess.WRITE)

	if save_file == null:
		print("opening file %s failed", path)
		return

	var is_successful := save_file.store_line(save_file_content)

	if not is_successful:
		print("saving to file %s failed" % path)


func _on_load_file_dialog_file_selected(path: String) -> void:
	var vertices_file := FileAccess.open(path, FileAccess.READ)

	if vertices_file == null:
		print("opening file %s failed", path)
		return

	var file_content := vertices_file.get_as_text()

	var parsed_vertices: Array = JSON.parse_string(file_content)

	clear_vertex_ui_elements()

	var vertices: PackedVector3Array
	vertices.resize(parsed_vertices.size())

	var i := 0
	for vertex_with_name: Dictionary in parsed_vertices:
		var vertex_name: String = vertex_with_name["name"]
		var x: float = vertex_with_name["x"]
		var y: float = vertex_with_name["y"]
		var z: float = vertex_with_name["z"]

		vertices[i] = Vector3(x, y, z)

		add_new_vertex_ui_element(x, y, z, vertex_name)

		i += 1

	create_polyhedron_from_vertices(vertices)
