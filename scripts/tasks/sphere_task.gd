extends Task

var radius: TaskFloatValue = TaskFloatValue.with_min_max(1.0, 5.0) \
.with_on_set(func() -> void: sphere.radius = radius.value)

@onready var sphere: Sphere = $Sphere


func difficulty() -> Global.TaskDifficulty:
	return Global.TaskDifficulty.EASY


func values() -> Dictionary[String, TaskFloatValue]:
	return { "Radius": radius }


func area_tip() -> String:
	return "A sphere's area is 4 × π × radius²"


func volume_tip() -> String:
	return "A sphere's volume is (4/3) × π × radius³"


func steps() -> Array[Step]:
	return [
		Step.new(
			"1. Calculate area",
			"A sphere's area is 4 × π × radius²",
			2,
			sphere.area,
		),
		Step.new(
			"2. Calculate volume",
			"A sphere's volume is (4/3) × π × radius³",
			2,
			sphere.volume,
		),
	]
