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
			"A cube's area is side × side",
			0,
			pyramid.base_area,
		),
		Step.new(
			"Calculate height of a side triangle",
			"TODO",
			1,
			pyramid.lateral_triangle_height,
		),
		Step.new(
			"Calculate area of one side triangle",
			"TODO",
			1,
			pyramid.lateral_triangle_area,
		),
		Step.new(
			"Calculate area of all side triangles",
			"TODO",
			1,
			func() -> float: return 4.0 * pyramid.lateral_triangle_area(),
		),
	]
