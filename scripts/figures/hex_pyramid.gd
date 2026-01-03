class_name HexPyramid
extends Polyhedron

var base_side_length: float:
	set(value):
		base_side_length = value
		scale_vertices()
		change_properties()

var height: float:
	set(value):
		height = value
		scale_vertices()
		change_properties()


func _ready() -> void:
	vertices = Poly.HEX_PYRAMID_VERTICES.duplicate()
	super._ready()


func scale() -> Vector3:
	return Vector3(base_side_length, height, base_side_length)


func area() -> float:
	return base_area() + 6.0 * lateral_triangle_area()


func volume() -> float:
	return base_area() * height / 3.0


func base_area() -> float:
	return 6.0 * base_triangle_area()


func lateral_triangle_area() -> float:
	return base_side_length * lateral_triangle_height()


func lateral_triangle_height() -> float:
	return sqrt(base_triangle_height() ** 2 / 4.0 + height ** 2)


func base_triangle_area() -> float:
	return base_side_length * base_triangle_height()


func base_triangle_height() -> float:
	# sqrt(3.0) / 2.0
	return 0.866025 * base_side_length


func scale_vertices() -> void:
	var s := scale()
	for i in vertices.size():
		vertices[i] = Poly.HEX_PYRAMID_VERTICES[i] * s
