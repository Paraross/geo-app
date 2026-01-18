extends CubeTaskBase

var side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0, 1) \
.with_on_set(func() -> void: cube.side_length = side_length.value)


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Side": side_length }
