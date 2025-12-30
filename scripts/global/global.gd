extends Node

enum TaskDifficulty {
	EASY,
	MEDIUM,
	HARD,
}


func round_with_digits(x: float, digits: int) -> float:
	var shift := 10.0 ** digits
	var rounded := roundf(x * shift) / shift
	return rounded


func clear_grid(grid: GridContainer) -> void:
	for child in grid.get_children():
		child.queue_free()
