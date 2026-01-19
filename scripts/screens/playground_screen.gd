class_name PlaygroundScreen
extends Screen

enum VertexIssue {
	DUPLICATE,
	NOT_IN_POLY,
}

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
@onready var scroll_container: ScrollContainer = $HBoxContainer/RightPanel/RightVBox/ScrollContainer
@onready var vertices_vbox: VBoxContainer = right_vbox.get_node("ScrollContainer/VBox/VerticesVBox")

@onready var area_spin_box: SpinBox = $HBoxContainer/RightPanel/RightVBox/PropertiesContainer/AreaSpinBox
@onready var volume_spin_box: SpinBox = $HBoxContainer/RightPanel/RightVBox/PropertiesContainer/VolumeSpinBox

@onready var sync_warning_label: Label = $HBoxContainer/RightPanel/RightVBox/VerticesHeaderContainer/SyncWarningLabel
@onready var new_vertex_button: Button = $HBoxContainer/RightPanel/RightVBox/VerticesHeaderContainer/NewVertexButton
@onready var vertex_visibility_button: Button = $HBoxContainer/RightPanel/RightVBox/VerticesHeaderContainer/VertexVisibilityButton
@onready var save_to_file_button: Button = $HBoxContainer/RightPanel/RightVBox/VerticesHeaderContainer/SaveToFileButton
@onready var create_polyhedron_button: Button = $HBoxContainer/RightPanel/RightVBox/VerticesHeaderContainer/CreatePolyhedronButton

@onready var popup: PopupPanel = $Popup

@onready var save_file_dialog: FileDialog = $SaveFileDialog
@onready var load_file_dialog: FileDialog = $LoadFileDialog


func _ready() -> void:
	for shape in SHAPE_OPTIONS:
		shape_button.add_item(shape)
	shape_button.selected = 0

	polyhedron_environment.polyhedron.vertex_sphere_clicked.connect(
		func(_index: int) -> void:
			update_vertex_visibility_button()
	)


func on_entered() -> void:
	clear_vertex_ui_elements()
	set_properties_spin_box_step()


func on_left() -> void:
	reset()


func reset() -> void:
	polyhedron_environment.unload_polyhedron()


func add_new_vertex_ui_element(x: float, y: float, z: float, vertex_name: String = "") -> VertexUiElement:
	var vertex_ui_element: VertexUiElement = preload("res://scenes/vertex_ui_element.tscn").instantiate()

	vertex_ui_elements.append(vertex_ui_element)
	vertices_vbox.add_child(vertex_ui_element)

	var remove_vertex := func() -> void:
		remove_vertex_ui_element(vertex_ui_element)

	vertex_ui_element.remove_button.pressed.connect(remove_vertex)

	vertex_ui_element.vertex_name_changed.connect(update_vertex_name)

	vertex_ui_element.vertex_name = vertex_name if vertex_name != "" else "Vertex %s" % vertex_ui_elements.size()
	vertex_ui_element.index = vertex_ui_elements.size() - 1

	var step := 1.0 / 10.0 ** Settings.coordinate_precision
	vertex_ui_element.x_spinbox.step = step
	vertex_ui_element.y_spinbox.step = step
	vertex_ui_element.z_spinbox.step = step

	vertex_ui_element.x_spinbox.value = x
	vertex_ui_element.y_spinbox.value = y
	vertex_ui_element.z_spinbox.value = z

	var create_poly := func(_new_value: float) -> void:
		create_polyhedron_from_vertices(get_vertices_from_ui())

	vertex_ui_element.x_spinbox.value_changed.connect(create_poly)
	vertex_ui_element.y_spinbox.value_changed.connect(create_poly)
	vertex_ui_element.z_spinbox.value_changed.connect(create_poly)

	return vertex_ui_element


func remove_vertex_ui_element(element: VertexUiElement) -> void:
	element.queue_free()
	vertex_ui_elements.erase(element)

	for i in vertex_ui_elements.size():
		var vertex_ui_element := vertex_ui_elements[i]
		vertex_ui_element.index = i

	update_create_polyhedron_button()


func clear_vertex_ui_elements() -> void:
	for vertex_ui_element: VertexUiElement in vertices_vbox.get_children():
		vertex_ui_element.queue_free()
		vertices_vbox.remove_child(vertex_ui_element)
	vertex_ui_elements.clear()


func get_vertices_from_ui() -> PackedVector3Array:
	var vertices := PackedVector3Array()
	vertices.resize(vertex_ui_elements.size())

	for i in range(vertex_ui_elements.size()):
		vertices[i] = vertex_ui_elements[i].get_vertex()

	return vertices


func are_poly_verts_equal_to_ui() -> bool:
	return polyhedron_environment.polyhedron.vertices == get_vertices_from_ui()


func get_unsynced_vertex_indices() -> Array:
	var unsynced_vertex_indices := PackedInt32Array()
	var issues: Array[VertexIssue] = []

	var polyhedron_vertices := polyhedron_environment.polyhedron.vertices

	var already_inserted := PackedVector3Array()
	for i in range(vertex_ui_elements.size()):
		var vertex_ui_element := vertex_ui_elements[i]
		var ui_vertex := vertex_ui_element.get_vertex()

		if ui_vertex in already_inserted:
			unsynced_vertex_indices.append(vertex_ui_element.index)
			issues.append(VertexIssue.DUPLICATE)
		elif ui_vertex in polyhedron_vertices:
			already_inserted.append(vertex_ui_element.get_vertex())

		if ui_vertex not in polyhedron_vertices:
			unsynced_vertex_indices.append(vertex_ui_element.index)
			issues.append(VertexIssue.NOT_IN_POLY)

	# GDScript to najgorszy język na świecie
	return [unsynced_vertex_indices, issues]


func update_create_polyhedron_button() -> void:
	if are_poly_verts_equal_to_ui():
		create_polyhedron_button.disabled = true
		create_polyhedron_button.tooltip_text = "The vertices of the diplayed polyhedron are the same as the vertices on the right."
		sync_warning_label.visible = false
	else:
		create_polyhedron_button.disabled = false
		create_polyhedron_button.tooltip_text = "The vertices of the diplayed polyhedron are different from the vertices on the right.\nPress to update."
		sync_warning_label.visible = true

	var gowno := get_unsynced_vertex_indices()
	var unsynced_verts: PackedInt32Array = gowno[0]
	var issues: Array[VertexIssue] = gowno[1]

	for i in range(vertex_ui_elements.size()):
		var vertex_ui_element := vertex_ui_elements[i]

		var unsynced_index := unsynced_verts.find(vertex_ui_element.index)

		if unsynced_index == -1:
			vertex_ui_element.hide_sync_warning_label()
			continue

		var issue := issues[unsynced_index]
		vertex_ui_element.show_sync_warning_label_for_issue(issue)


func create_polyhedron_from_vertices(vertices: PackedVector3Array) -> bool:
	if not Poly.are_valid_polyhedron_vertices(vertices):
		update_create_polyhedron_button()
		return false

	var vertex_names: PackedStringArray
	vertex_names.resize(vertex_ui_elements.size())
	for i in range(vertex_ui_elements.size()):
		vertex_names[i] = vertex_ui_elements[i].vertex_name

	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertices = vertices
	polyhedron.update_vertices(vertex_names)

	update_create_polyhedron_button()
	update_vertex_visibility_button()
	update_properties_values()

	return true


func update_properties_values() -> void:
	var polyhedron := polyhedron_environment.polyhedron
	area_spin_box.value = polyhedron.area()
	volume_spin_box.value = polyhedron.volume()


func set_properties_spin_box_step() -> void:
	var step := 1.0 / 10.0 ** (Settings.coordinate_precision + 1)
	area_spin_box.step = step
	volume_spin_box.step = step


func update_vertex_name(new_name: String, index: int) -> void:
	print("%s. name changed to %s" % [index, new_name])
	var polyhedron := polyhedron_environment.polyhedron
	polyhedron.vertex_spheres[index].vertex_name = new_name


func update_vertex_visibility_button() -> void:
	if polyhedron_environment.polyhedron.is_any_vertex_label_visible():
		vertex_visibility_button.text = "Hide labels"
	else:
		vertex_visibility_button.text = "Show labels"


func _on_new_vertex_button_pressed() -> void:
	add_new_vertex_ui_element(0.0, 0.0, 0.0)
	update_create_polyhedron_button()


func _on_create_polyhedron_button_pressed() -> void:
	var vertices := get_vertices_from_ui()
	var was_successful := create_polyhedron_from_vertices(vertices)

	if not was_successful:
		popup.show()


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


func _on_vertex_visibility_button_pressed() -> void:
	var polyhedron := polyhedron_environment.polyhedron
	var is_any_label_visible := polyhedron.is_any_vertex_label_visible()
	for vertex_sphere in polyhedron.vertex_spheres:
		vertex_sphere.label_visibility_requested.emit(not is_any_label_visible)
	update_vertex_visibility_button()
