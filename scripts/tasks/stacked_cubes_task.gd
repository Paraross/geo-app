extends Task

var bottom_side_length: TaskFloatValue = TaskFloatValue.with_min_max(2.0, 10.0) \
.with_on_set(
	func() -> void:
		bottom_cube.side_length = bottom_side_length.value
		top_cube.position.y = bottom_side_length.value / 2.0 + top_side_length.value / 2.0
)

var top_side_length: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(
	func() -> void:
		top_cube.side_length = top_side_length.value
		top_cube.position.y = bottom_side_length.value / 2.0 + top_side_length.value / 2.0
)

@onready var bottom_cube: Cube = $BottomCube
@onready var top_cube: Cube = $TopCube


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.MEDIUM


func values() -> Dictionary[String, TaskFloatValue]:
	return {
		"Bottom Side": bottom_side_length,
		"Top Side": top_side_length,
	}


func area_tip() -> String:
	return "Calculate the total surface area of both cubes stacked together"


func volume_tip() -> String:
	return "The total volume is the sum of both cubes' volumes"


func steps() -> Array[Step]:
	return [
		Step.new(
			"Calculate bottom cube area",
			"A cube's total area is the sum of all its 6 face areas",
			0,
			bottom_cube.area,
		),
		Step.new(
			"Calculate top cube area",
			"A cube's total area is the sum of all its 6 face areas",
			0,
			top_cube.area,
		),
		Step.new(
			"Calculate the visible area of the top cube",
			"Only 5 faces of the top cube are visible",
			0,
			func() -> float: return 5.0 * top_cube.face_area()
		),
		Step.new(
			"Calculate the visible area of the bottom cube",
			"5 faces of the bottom cube are fully visible. One face is partially covered by one of the top cube's faces",
			0,
			func() -> float: return bottom_cube.area() - top_cube.face_area()
		),
		Step.new(
			"Calculate the area of the whole shape",
			"The bottom cube's volume is its side length cubed",
			0,
			func() -> float: return 5.0 * top_cube.face_area() + bottom_cube.area() - top_cube.face_area()
		),
		Step.new(
			"Calculate bottom cube volume",
			"The bottom cube's volume is its side length cubed",
			0,
			bottom_cube.volume,
		),
		Step.new(
			"Calculate top cube volume",
			"The top cube's volume is its side length cubed",
			0,
			top_cube.volume,
		),
		Step.new(
			"Calculate total volume",
			"Add the volumes of both cubes together",
			0,
			func() -> float: return bottom_cube.volume() + top_cube.volume()
		),
	]
