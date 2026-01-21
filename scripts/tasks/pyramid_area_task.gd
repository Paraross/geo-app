class_name PyramidAreaTask
extends PyramidTask

func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.HARD


func description() -> String:
	return """A pyramid is given. The pyramid has a square base.
The length of the base's side is [b]{Base side length}[/b].
The height of the pyramid is [b]{Height}[/b].
"""


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate base area",
			"The base is a square",
			0,
			pyramid.base_area,
		),
		Step.new(
			"Calculate height of a side triangle",
			"The Pythagorean theorem can be used for this",
			1,
			pyramid.lateral_triangle_height,
		),
		Step.new(
			"Calculate area of one side triangle",
			"A side triangle is a triangle whose base is the same as the side length of the pyramid's base",
			1,
			pyramid.lateral_triangle_area,
		),
		Step.new(
			"Calculate area of all side triangles",
			"There are 4 side triangles",
			1,
			func() -> float: return 4.0 * pyramid.lateral_triangle_area(),
		),
		Step.new(
			"Calculate total area of the pyramid",
			"The total area is the sum of the base area and the area of the side triangles",
			1,
			pyramid.area,
		),
	]
