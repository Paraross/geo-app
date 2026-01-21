@abstract class_name PrismTaskBase
extends Task

@onready var prism: Prism = $Prism


@abstract func difficulty() -> Global.TaskDifficulty


func description() -> String:
	return """A prism is given. The base of the prism is an isosceles triangle.
The base of the triangle has length [b]{Base base}[/b].
The height of the triangle is [b]{Base height}[/b].
The height of the the prism is [b]{Height}[/b]."""


@abstract func values() -> Dictionary[String, TaskFloatValue]


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate base area",
			"The base is a triangle whose base and height are given",
			1,
			prism.base_area,
		),
		Step.new(
			"Calculate area of the wall next to the base triangle's base",
			"The dimensions of this wall are the prism's height and the base's base",
			1,
			prism.bottom_wall_area,
		),
		Step.new(
			"Calculate base triangle's side length",
			"The Pythagorean theorem can be used when given the base and height",
			1,
			prism.base_area,
		),
		Step.new(
			"Calculate area of the wall next to the base triangle's side",
			"The dimensions of this wall are the prism's height and the base's side",
			1,
			prism.side_wall_area,
		),
		Step.new(
			"Calculate total area",
			"A prism has 2 bases, 2 \"side\" walls and 1 \"base\" wall",
			1,
			prism.area,
		),
		Step.new(
			"Calculate volume",
			"A prism's volume is the product of base area and height",
			1,
			prism.volume,
		),
	]
