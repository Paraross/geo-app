extends Task

var base_base: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: prism.base_base = base_base.value)
var base_height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: prism.base_height = base_height.value)
var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: prism.height = height.value)

@onready var prism: Prism = $Prism


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func description() -> String:
	return "Prism with base base: {Base base}, base height: {Base height}, height: {Height}"


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base base": base_base,
		"Base height": base_height,
		"Height": height,
	}


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate base area",
			"A triangular base area is (base × height) ÷ 2",
			1,
			prism.base_area,
		),
		Step.new(
			"Calculate total area",
			"A prism's total area is 2 × base area + side walls area",
			1,
			prism.area,
		),
		Step.new(
			"Calculate volume",
			"A prism's volume is base area × height",
			1,
			prism.volume,
		),
	]
