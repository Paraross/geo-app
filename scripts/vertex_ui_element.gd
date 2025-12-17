class_name VertexUiElement
extends Container

@onready var label: Label = $HBoxContainer/Label
@onready var remove_button: Button = $HBoxContainer/RemoveButton
@onready var coords_container: Container = $CoordsContainer
@onready var x_spinbox: SpinBox = coords_container.get_node("XSpinBox")
@onready var y_spinbox: SpinBox = coords_container.get_node("YSpinBox")
@onready var z_spinbox: SpinBox = coords_container.get_node("ZSpinBox")
