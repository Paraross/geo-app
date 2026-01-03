class_name Cuboid
extends Polyhedron

var width: float:
	set(value):
		width = value
		scale_vertices()
		change_properties()

var height: float:
	set(value):
		height = value
		scale_vertices()
		change_properties()

var length: float:
	set(value):
		length = value
		scale_vertices()
		change_properties()


func _ready() -> void:
	vertices = Poly.CUBE_VERTICES.duplicate()
	super._ready()


func scale() -> Vector3:
	return Vector3(width, height, length) / 2.0


func area() -> float:
	return 2.0 * (xy_face_area() + xz_face_area() + yz_face_area())


func volume() -> float:
	return width * height * length


func xy_face_area() -> float:
	return width * height


func xz_face_area() -> float:
	return width * length


func yz_face_area() -> float:
	return height * length


func scale_vertices() -> void:
	var s := scale()
	for i in vertices.size():
		vertices[i] = Poly.CUBE_VERTICES[i] * s
