class_name Prism
extends Polyhedron

var base_base: float:
	set(value):
		base_base = value
		scale_vertices()
		properties_changed.emit()

var base_height: float:
	set(value):
		base_height = value
		scale_vertices()
		properties_changed.emit()

var height: float:
	set(value):
		height = value
		scale_vertices()
		properties_changed.emit()


func _ready() -> void:
	vertices = Poly.PRISM_VERTICES.duplicate()
	super._ready()


func scale() -> Vector3:
	return Vector3(base_base, height, base_height) / 2.0


# correct only for a isosceles triangle
func area() -> float:
	var bottom_wall_area := base_base * height
	var base_side := sqrt((base_base / 2.0) ** 2.0 + base_height ** 2.0)
	var side_wall_area := base_side * height

	return 2.0 * base_area() + 2.0 * side_wall_area + bottom_wall_area


func volume() -> float:
	return base_area() * height


func base_area() -> float:
	return base_base * base_height / 2.0


func scale_vertices() -> void:
	var s := scale()
	for i in vertices.size():
		vertices[i] = Poly.PRISM_VERTICES[i] * s
