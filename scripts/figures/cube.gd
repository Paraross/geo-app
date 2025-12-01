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
		set_mesh()
		update_collision_shape()
		properties_changed.emit()

@onready var shape: ConvexPolygonShape3D:
	get:
		return collision_shape.shape
	set(value):
		collision_shape.shape = value


func _ready() -> void:
	super._ready()
	set_mesh()
	set_collision_shape()


func set_mesh() -> void:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	var verts: Array[PackedVector3Array] = [
		# Front face (z+)
		PackedVector3Array(
			[
				VERTICES[0],
				VERTICES[1],
				VERTICES[2],
				VERTICES[3],
			],
		),
		# Back face (z-)
		PackedVector3Array(
			[
				VERTICES[5],
				VERTICES[4],
				VERTICES[7],
				VERTICES[6],
			],
		),
		# Top face (y+)
		PackedVector3Array(
			[
				VERTICES[4],
				VERTICES[5],
				VERTICES[1],
				VERTICES[0],
			],
		),
		# Bottom face (y-)
		PackedVector3Array(
			[
				VERTICES[3],
				VERTICES[2],
				VERTICES[6],
				VERTICES[7],
			],
		),
		# Right face (x+)
		PackedVector3Array(
			[
				VERTICES[1],
				VERTICES[5],
				VERTICES[6],
				VERTICES[2],
			],
		),
		# Left face (x-)
		PackedVector3Array(
			[
				VERTICES[4],
				VERTICES[0],
				VERTICES[3],
				VERTICES[7],
			],
		),
	]

	arrays[Mesh.ARRAY_VERTEX] = flattened(verts)
	arrays[Mesh.ARRAY_NORMAL] = generate_normals(verts)
	arrays[Mesh.ARRAY_INDEX] = generate_indices(verts)

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh


func flattened(verts: Array[PackedVector3Array]) -> PackedVector3Array:
	var flattened := PackedVector3Array()

	for face_vertices in verts:
		for vertex in face_vertices:
			flattened.push_back(scaled(vertex))

	return flattened


# verts - array of face vertices, each index corresponds to a face
# minimum 3 vertices per face
func generate_normals(verts: Array[PackedVector3Array]) -> PackedVector3Array:
	var normals := PackedVector3Array()

	for face_vertices in verts:
		assert(face_vertices.size() >= 3)

		var vertex1 := face_vertices[0]
		var vertex2 := face_vertices[1]
		var vertex3 := face_vertices[2]

		var to_vertex2 := vertex2 - vertex1
		var to_vertex3 := vertex3 - vertex1

		var normal := to_vertex3.cross(to_vertex2).normalized()

		for j in range(face_vertices.size()):
			normals.push_back(normal)

	return normals


func generate_indices(verts: Array[PackedVector3Array]) -> PackedInt32Array:
	var indices := PackedInt32Array()

	var i := 0
	for face_vertices in verts:
		var vertex_count := face_vertices.size() 
		assert(vertex_count >= 3)

		var first_index := i
		for j in range(vertex_count - 2):
			var second_index := first_index + j + 1
			var third_index := second_index + 1

			indices.push_back(first_index)
			indices.push_back(second_index)
			indices.push_back(third_index)

		i += vertex_count


	return indices


func set_collision_shape() -> void:
	var cp_shape := ConvexPolygonShape3D.new()
	cp_shape.points = vertices()
	shape = cp_shape


func update_collision_shape() -> void:
	shape.points = vertices()


func scaled(vertex: Vector3) -> Vector3:
	return vertex * side_length / 2.0


func vertices() -> Array[Vector3]:
	var verts: Array[Vector3] = VERTICES.duplicate()
	for i in range(verts.size()):
		verts[i] = scaled(verts[i])
	return verts


func edges() -> Array[Edge]:
	return edges1


func area() -> float:
	return 6.0 * side_length * side_length


func volume() -> float:
	return side_length * side_length * side_length
