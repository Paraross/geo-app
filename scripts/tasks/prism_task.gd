extends Task

# x
var base_base: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: prism.base_base = base_base.value)
# y
var base_height: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: prism.base_height = base_height.value)
# z
var height: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(func() -> void: prism.height = height.value)

@onready var prism: Prism = $Prism


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Base base": base_base,
		"Base height": base_height,
		"Height": height,
	}


func area_tip() -> String:
	return "A prism's total area is 2 × base area + side walls area"


func volume_tip() -> String:
	return "A prism's volume is base area × height"


func steps() -> Array[Step]:
	return [
		Step.new(
			"1. Calculate base area",
			"A triangular base area is (base × height) ÷ 2",
			func() -> float: return prism.base_area()
		),
		Step.new(
			"2. Calculate total area",
			"A prism's total area is 2 × base area + side walls area",
			func() -> float: return prism.area()
		),
		Step.new(
			"3. Calculate volume",
			"A prism's volume is base area × height",
			func() -> float: return prism.volume()
		),
	]
