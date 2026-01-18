@abstract class_name PrismTaskBase
extends Task

@onready var prism: Prism = $Prism


@abstract func difficulty() -> Global.TaskDifficulty


func description() -> String:
	return """A prism is given. The prism has a triangular base.
The base of the triangle has length [b]{Base base}[/b].
The height of the triangle is [b]{Base height}[/b].
The height of the the prism is [b]{Height}[/b]."""


@abstract func values() -> Dictionary[String, TaskFloatValue]


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
