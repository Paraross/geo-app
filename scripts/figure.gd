@abstract class_name Figure
extends MeshInstance3D

signal properties_changed

@abstract func vertices() -> Array[Vector3]

@abstract func scaled_vertices() -> Array[Vector3]

@abstract func area() -> float

@abstract func volume() -> float
