class_name Cube
extends Polyhedron

var side_length: float:
	set(value):
		side_length = value

		var s := scale()
		for i in vertices.size():
			vertices[i] = Poly.CUBE_VERTICES[i] * s

		properties_changed.emit()


func _ready() -> void:
	vertices = Poly.CUBE_VERTICES.duplicate()
	super._ready()


func scale() -> Vector3:
	return Vector3(side_length, side_length, side_length) / 2.0


func area() -> float:
	return 6.0 * face_area()


func volume() -> float:
	return side_length * side_length * side_length


func face_area() -> float:
	return side_length * side_length
