class_name VertexUiElement
extends HBoxContainer

signal vertex_name_changed(new_name: String, index: int)

const ISSUE_LABEL_MAP: Dictionary[PlaygroundScreen.VertexIssue, String] = {
	PlaygroundScreen.VertexIssue.DUPLICATE: "Duplicate vertex",
	PlaygroundScreen.VertexIssue.NOT_IN_POLY: "Not in polyhedron",
}

const ISSUE_TOOLTIP_MAP: Dictionary[PlaygroundScreen.VertexIssue, String] = {
	PlaygroundScreen.VertexIssue.DUPLICATE: "This is a duplicate vertex. Each vertex must be unique.",
	PlaygroundScreen.VertexIssue.NOT_IN_POLY: "The displayed polyhedron does not contain this vertex.",
}

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
@onready var sync_warning_label: Label = $SyncWarningLabel


func get_vertex() -> Vector3:
	var x := x_spinbox.value
	var y := y_spinbox.value
	var z := z_spinbox.value
	return Vector3(x, y, z)


func hide_sync_warning_label() -> void:
	sync_warning_label.visible = false


func show_sync_warning_label_for_issue(issue: PlaygroundScreen.VertexIssue) -> void:
	if sync_warning_label.visible:
		return

	sync_warning_label.text = ISSUE_LABEL_MAP[issue]
	sync_warning_label.tooltip_text = ISSUE_TOOLTIP_MAP[issue]
	sync_warning_label.visible = true


func _on_name_line_edit_text_changed(new_text: String) -> void:
	vertex_name_changed.emit(new_text, index)
