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


func round_task_data(x: float) -> float:
	return round_with_digits(x, Settings.data_precision())


func round_task_answer(x: float) -> float:
	return round_with_digits(x, Settings.answer_precision())


func clear_grid(grid: GridContainer) -> void:
	for child in grid.get_children():
		child.queue_free()
