class_name Cube
extends Figure

const VERTICES: Array[Vector3] = [
	# front
	Vector3(-1, 1, 1), # 1 left top near
	Vector3(1, 1, 1), # 2 right top near
	Vector3(1, -1, 1), # 6 right bottom near
	Vector3(-1, -1, 1), # 5 left bottom near
	# back
	Vector3(-1, 1, -1), # 0 left top far
	Vector3(1, 1, -1), # 3 right top far
	Vector3(1, -1, -1), # 7 right bottom far
	Vector3(-1, -1, -1), # 4 left bottom far
	# alt back
	# Vector3(1, 1, -1), # 3 right top far
	# Vector3(-1, 1, -1), # 0 left top far
	# Vector3(-1, -1, -1), # 4 left bottom far
	# Vector3(1, -1, -1), # 7 right bottom far
]

var edges1: Array[Edge] = [
	# front
	Edge.new(0, 1),
	Edge.new(1, 2),
	Edge.new(2, 3),
	Edge.new(3, 0),
	# back
	Edge.new(4, 5),
	Edge.new(5, 6),
	Edge.new(6, 7),
	Edge.new(7, 4),
	# horizontal
	Edge.new(0, 4),
	Edge.new(1, 5),
	Edge.new(2, 6),
	Edge.new(3, 7),
]

var side_length: float:
	set(value):
		side_length = value
		var vec := Vector3(value, value, value)
		shape.size = vec
		update_mesh()
		properties_changed.emit()

@onready var shape: BoxShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	super._ready()
	update_mesh()


func update_mesh() -> void:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	var half_size := side_length / 2.0

	# Define vertices for each face (4 vertices per face, 6 faces)
	var verts := PackedVector3Array(
		[
			# Front face (z+)
			VERTICES[0],
			VERTICES[1],
			VERTICES[2],
			VERTICES[3],
			# Back face (z-)
			VERTICES[5],
			VERTICES[4],
			VERTICES[7],
			VERTICES[6],
			# Top face (y+)
			VERTICES[4],
			VERTICES[5],
			VERTICES[1],
			VERTICES[0],
			# Bottom face (y-)
			VERTICES[3],
			VERTICES[2],
			VERTICES[6],
			VERTICES[7],
			# Right face (x+)
			VERTICES[1],
			VERTICES[5],
			VERTICES[6],
			VERTICES[2],
			# Left face (x-)
			VERTICES[4],
			VERTICES[0],
			VERTICES[3],
			VERTICES[7],
		],
	)

	for i in verts.size():
		verts[i] *= half_size

	var normals := PackedVector3Array()
	normals.resize(verts.size())

	for i in range(0, verts.size(), 4):
		var triangle_vertex1 := verts[i]
		var triangle_vertex2 := verts[i + 1]
		var triangle_vertex3 := verts[i + 2]

		var to_vertex2 := triangle_vertex2 - triangle_vertex1
		var to_vertex3 := triangle_vertex3 - triangle_vertex1

		var normal := to_vertex3.cross(to_vertex2).normalized()

		normals[i] = normal
		normals[i + 1] = normal
		normals[i + 2] = normal
		normals[i + 3] = normal

	# Define indices for triangles (2 triangles per face, 6 faces)
	var indices := PackedInt32Array(
		[
			# Front
			0, 1, 2,
			0, 2, 3,
			# Back
			4, 5, 6,
			4, 6, 7,
			# Top
			8, 9, 10,
			8, 10, 11,
			# Bottom
			12, 13, 14,
			12, 14, 15,
			# Right
			16, 17, 18,
			16, 18, 19,
			# Left
			20, 21, 22,
			20, 22, 23,
		],
	)

	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh


func vertices() -> Array[Vector3]:
	var vertices := VERTICES.duplicate()
	for i in range(vertices.size()):
		vertices[i] *= side_length / 2.0
	return vertices


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
