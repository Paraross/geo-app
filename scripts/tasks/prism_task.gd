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
	return """A prism is given. The prism has a triangular base.
The base of the triangle has length [b]{Base base}[/b].
The height of the triangle is [b]{Base height}[/b].
The height of the the prism is [b]{Height}[/b]."""


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
