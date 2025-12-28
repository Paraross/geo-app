class_name VertexUiElement
extends HBoxContainer

signal vertex_name_changed(new_name: String, index: int)

var index: int

var vertex_name: String:
	get:
		return name_line_edit.text
	set(value):
		name_line_edit.text = value

@onready var name_line_edit: LineEdit = $NameLineEdit
@onready var remove_button: Button = $RemoveButton
@onready var coords_container: Container = $CoordsContainer
@onready var x_spinbox: SpinBox = coords_container.get_node("XSpinBox")
@onready var y_spinbox: SpinBox = coords_container.get_node("YSpinBox")
@onready var z_spinbox: SpinBox = coords_container.get_node("ZSpinBox")


func get_vertex() -> Vector3:
	var x := x_spinbox.value
	var y := y_spinbox.value
	var z := z_spinbox.value
	return Vector3(x, y, z)


func _on_name_line_edit_text_submitted(new_text: String) -> void:
	vertex_name_changed.emit(new_text, index)
