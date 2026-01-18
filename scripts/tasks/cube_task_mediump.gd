extends CubeTaskBase

var side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0, 1) \
.with_on_set(func() -> void: cube.side_length = side_length.value)


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Side": side_length }

func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate face area",
			"A cube face is a square, so its area is side × side",
			2,
			cube.face_area,
		),
		Step.new(
			"Calculate total area",
			"A cube's total area is the sum of all its 6 face areas",
			2,
			cube.area,
		),
		Step.new(
			"Calculate volume",
			"A cube's volume is the area of one face multiplied by its side length",
			2,
			cube.volume,
		),
	]
