extends Node

enum TaskDifficulty {
	EASY,
	MEDIUM,
	HARD,
}

var all_tasks: Array[Task]

func round_with_digits(x: float, digits: int) -> float:
	var shift := 10.0 ** digits
	var rounded := roundf(x * shift) / shift
	return rounded
