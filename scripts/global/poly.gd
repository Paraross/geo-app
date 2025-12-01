extends Node


func flatten_faces(verts: Array[PackedVector3Array]) -> PackedVector3Array:
	var flattened := PackedVector3Array()

	for face_vertices in verts:
		for vertex in face_vertices:
			flattened.push_back(vertex)

	return flattened


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
