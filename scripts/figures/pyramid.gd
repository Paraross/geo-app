class_name Pyramid
extends Polyhedron

var base_side_length: float:
	set(value):
		base_side_length = value
		scale_vertices()
		properties_changed.emit()

var height: float:
	set(value):
		height = value
		scale_vertices()
		properties_changed.emit()


func _ready() -> void:
	vertices = Poly.PYRAMID_VERTICES.duplicate()
	super._ready()


func scale() -> Vector3:
	return Vector3(base_side_length, height, base_side_length) / 2.0


func area() -> float:
	return base_area() + 4.0 * lateral_triangle_area()


func volume() -> float:
	return base_area() * height / 3.0


func base_area() -> float:
	return base_side_length ** 2.0


func lateral_triangle_area() -> float:
	var a := base_side_length
	return a * sqrt(base_area() + 4 * height ** 2) / 4.0


func scale_vertices() -> void:
	var s := scale()
	for i in vertices.size():
		vertices[i] = Poly.PYRAMID_VERTICES[i] * s
