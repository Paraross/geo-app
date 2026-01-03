class_name CuboidTask
extends Task

var width: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: cuboid.width = width.value)

var height: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: cuboid.height = height.value)

var length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: cuboid.length = length.value)

@onready var cuboid: Cuboid = $Cuboid


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func description() -> String:
	return "Cuboid with width = [b]{Width}[/b], height = [b]{Height}[/b], length = [b]{Length}[/b]"


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Width": width,
		"Height": height,
		"Length": length,
	}


func area_tip() -> String:
	return ""


func volume_tip() -> String:
	return ""


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate front face area",
			"The cuboid's front face is a rectangle whose dimensions are width, height",
			0,
			cuboid.xy_face_area,
		),
		Step.new(
			"Calculate top face area",
			"The cuboid's top face is a rectangle whose dimensions are width, length",
			0,
			cuboid.xz_face_area,
		),
		Step.new(
			"Calculate side face area",
			"The cuboid's side face is a rectangle whose dimensions are height, length",
			0,
			cuboid.yz_face_area,
		),
		Step.new(
			"Calculate total area",
			"A cuboid's total area is 2 * (front area + top area + side area)",
			0,
			cuboid.area,
		),
		Step.new(
			"Calculate volume",
			"A cuboid's volume is width * height * length",
			0,
			cuboid.volume,
		),
	]
