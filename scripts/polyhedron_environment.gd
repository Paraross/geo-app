class_name PolyhedronEnvironment
extends FigureEnvironment

@onready var polyhedron: Polyhedron:
	get:
		if polyhedron == null:
			load_polyhedron()
		return polyhedron


func _ready() -> void:
	load_polyhedron()


func load_polyhedron() -> void:
	polyhedron = preload("res://scenes/figures/polyhedron.tscn").instantiate()
	add_child(polyhedron)


func unload_polyhedron() -> void:
	if polyhedron != null:
		remove_child(polyhedron)
		polyhedron = null
