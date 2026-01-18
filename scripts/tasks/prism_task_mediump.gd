extends PrismTaskBase

var base_base: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0, 1) \
.with_on_set(func() -> void: prism.base_base = base_base.value)
var base_height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0, 1) \
.with_on_set(func() -> void: prism.base_height = base_height.value)
var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0, 1) \
.with_on_set(func() -> void: prism.height = height.value)


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base base": base_base,
		"Base height": base_height,
		"Height": height,
	}
