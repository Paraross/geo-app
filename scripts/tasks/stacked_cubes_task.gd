extends Task

var bottom_side_length: TaskFloatValue = TaskFloatValue.default() \
.with_on_set(
	func() -> void:
		bottom_cube.side_length = bottom_side_length.value
		top_cube.position.y = bottom_side_length.value / 2.0 + top_side_length.value / 2.0
)

var top_side_length: TaskFloatValue = TaskFloatValue.with_min_max(
	Settings.default_task_data_min_value / 2.0,
	Settings.default_task_data_max_value / 2.0,
).with_on_set(
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
			"1. Calculate bottom cube area",
			"A cube's total area is the sum of all its 6 face areas",
			bottom_cube.area,
		),
		Step.new(
			"2. Calculate top cube area",
			"A cube's total area is the sum of all its 6 face areas",
			top_cube.area,
		),
		Step.new(
			"3. Calculate the visible area of the top cube",
			"Only 5 faces of the top cube are visible",
			func() -> float: return 5.0 * top_cube.face_area()
		),
		Step.new(
			"4. Calculate the visible area of the bottom cube",
			"5 faces of the bottom cube are fully visible. One face is partially covered by one of the top cube's faces",
			func() -> float: return bottom_cube.area() - top_cube.face_area()
		),
		Step.new(
			"5. Calculate the area of the whole shape",
			"The bottom cube's volume is its side length cubed",
			func() -> float: return 5.0 * top_cube.face_area() + bottom_cube.area() - top_cube.face_area()
		),
		# Step.new(
		# 	"6. Calculate bottom cube volume",
		# 	"The bottom cube's volume is its side length cubed",
		# 	bottom_cube.volume,
		# ),
		# Step.new(
		# 	"7. Calculate top cube volume",
		# 	"The top cube's volume is its side length cubed",
		# 	top_cube.volume,
		# ),
		# Step.new(
		# 	"8. Calculate total volume",
		# 	"Add the volumes of both cubes together",
		# 	func() -> float: return bottom_cube.volume() + top_cube.volume()
		# ),
	]
