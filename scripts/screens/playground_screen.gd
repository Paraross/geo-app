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
	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()


func on_left() -> void:
	reset()


func reset() -> void:
	polyhedron_environment.unload_polyhedron()


func add_new_vertex_ui_element(vertex_name: String = "") -> VertexUiElement:
	var vertex_ui_element: VertexUiElement = preload("res://scenes/vertex_ui_element.tscn").instantiate()

	vertex_ui_elements.append(vertex_ui_element)
	vertices_vbox.add_child(vertex_ui_element)

	vertex_ui_element.remove_button.pressed.connect(
		func() -> void:
			remove_vertex_ui_element(vertex_ui_element)
	)
	
	vertex_ui_element.label.text = vertex_name if vertex_name != "" else "Vertex %s" % vertex_ui_elements.size()

	return vertex_ui_element


func remove_vertex_ui_element(element: VertexUiElement) -> void:
	element.queue_free()
	# remove_child(element)
	vertex_ui_elements.erase(element)


func create_polyhedron_from_vertices(vertices: PackedVector3Array) -> void:
	if not Poly.are_valid_polyhedron_vertices(vertices):
		popup.show()
		return

	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertices = vertices
	polyhedron.update_vertices()


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

	create_polyhedron_from_vertices(vertices)


func _on_load_button_pressed() -> void:
	var vertices := SHAPE_VERTICES[shape_button.selected]

	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()

	for v in vertices:
		var new_vertex_ui_element := add_new_vertex_ui_element()
		new_vertex_ui_element.x_spinbox.value = v.x
		new_vertex_ui_element.y_spinbox.value = v.y
		new_vertex_ui_element.z_spinbox.value = v.z

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
		var x := element.x_spinbox.value
		var y := element.y_spinbox.value
		var z := element.z_spinbox.value
		vertices[i] = Vector3(x, y, z)

		verts_for_json[i] = { "name": element.label.text, "x": x, "y": y, "z": z }

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

	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()

	var vertices: PackedVector3Array
	vertices.resize(parsed_vertices.size())

	var i := 0
	for vertex_with_name: Dictionary in parsed_vertices:
		var vertex_name: String = vertex_with_name["name"]
		var x: float = vertex_with_name["x"]
		var y: float = vertex_with_name["y"]
		var z: float = vertex_with_name["z"]

		vertices[i] = Vector3(x, y, z)

		var new_vertex_ui_element := add_new_vertex_ui_element(vertex_name)
		new_vertex_ui_element.x_spinbox.value = x
		new_vertex_ui_element.y_spinbox.value = y
		new_vertex_ui_element.z_spinbox.value = z

		i += 1

	create_polyhedron_from_vertices(vertices)
