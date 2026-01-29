class_name VertexSphere
extends Sphere

var vertex_name: String = "":
	set(value):
		vertex_name = value
		properties_changed.emit()

@onready var label_component: LabelComponent = $LabelComponent


func is_label_visible() -> bool:
	return label_component != null and label_component.visible
