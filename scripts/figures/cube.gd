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

	var verts := extract_faces(VERTICES)

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


# TODO: run this only once at ready, store normalized faces, then multiply when needed
func extract_faces(vertices: Array[Vector3]) -> Array[PackedVector3Array]:
	var faces: Array[PackedVector3Array] = []

	const EPS := 0.0001

	for i in range(vertices.size()):
		for j in range(i + 1, vertices.size()):
			for k in range(j + 1, vertices.size()):
				var a := vertices[i]
				var b := vertices[j]
				var c := vertices[k]

				var normal := (b - a).cross(c - a)
				if normal.length() < EPS:
					continue

				var found_side: Variant = null # nullable bool
				var valid := true

				for p in vertices:
					if p == a or p == b or p == c:
						continue

					var d := normal.dot(p - a)

					if abs(d) < EPS:
						continue

					var side := d > 0
					if found_side == null:
						found_side = side
					elif side != found_side:
						valid = false
						break

				if not valid:
					continue
				
				if not found_side:
					normal = -normal

				# Collect all coplanar vertices
				var face: Array[Vector3] = []
				for v in vertices:
					if abs(normal.dot(v - a)) < EPS:
						face.append(v)

				# Sort vertices cyclically
				var center := Vector3.ZERO
				for v in face:
					center += v
				center /= face.size()

				# Build basis for sorting
				var axis_x := (face[0] - center).normalized()
				var axis_y := normal.cross(axis_x).normalized()

				face.sort_custom(
					func(v1: Vector3, v2: Vector3) -> bool:
						var va := v1 - center
						var vb := v2 - center
						var angle_a := atan2(va.dot(axis_y), va.dot(axis_x))
						var angle_b := atan2(vb.dot(axis_y), vb.dot(axis_x))
						return angle_a < angle_b
				)

				var packed_face := PackedVector3Array(face)

				# Avoid duplicates
				var already := false
				for existing in faces:
					if same_face(existing, packed_face):
						already = true
						break

				if not already:
					faces.append(packed_face)

	return faces


func same_face(f1: PackedVector3Array, f2: PackedVector3Array) -> bool:
	if f1.size() != f2.size():
		return false
	for p in f1:
		if not p in f2:
			return false
	return true


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
