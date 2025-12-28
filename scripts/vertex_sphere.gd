class_name VertexSphere
extends Sphere

var vertex_name: String = "":
	set(value):
		vertex_name = value
		properties_changed.emit()
