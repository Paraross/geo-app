extends Node

enum TaskDifficulty {
	EASY,
	MEDIUM,
	HARD,
}

func truncate(x: float) -> float:
	return float(roundf(100.0 * x)) / 100.0


func truncate_round(x: float) -> float:
	var truncated := truncate(x)
	return roundf(10.0 * truncated) / 10.0
