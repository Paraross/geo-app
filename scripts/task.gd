@abstract class_name Task
extends Node3D

var steps1: Array[Step]


func _ready() -> void:
	var values := values()
	for value_name in values:
		values[value_name].on_set.call()

	steps1 = steps()


@abstract func difficulty() -> Global.TaskDifficulty


@abstract func description() -> String


@abstract func values() -> Dictionary[String, TaskFloatValue]


# TODO: remove
@abstract func area_tip() -> String


# TODO: remove
@abstract func volume_tip() -> String


func randomize_values() -> void:
	var values := values()
	for value_name in values:
		values[value_name].randomize_and_round()


func steps() -> Array[Step]:
	return steps1


func step_count() -> int:
	return steps1.size()


func step_title(step: int) -> String:
	return steps1[step].title


func correct_answer_for_step(step: int) -> float:
	return steps1[step].correct_answer()


func tip_for_step(step: int) -> String:
	return steps1[step].tip


class Step:
	var title: String
	var tip: String
	var answer_precision_digits: int
	var _correct_answer_func: Callable


	func _init(
			title: String,
			tip: String,
			answer_precision_digits: int,
			correct_answer_func: Callable,
	) -> void:
		self.title = title
		self.tip = tip
		self.answer_precision_digits = answer_precision_digits
		self._correct_answer_func = correct_answer_func


	func correct_answer() -> float:
		var answer: float = _correct_answer_func.call()
		return Global.round_with_digits(answer, answer_precision_digits)
