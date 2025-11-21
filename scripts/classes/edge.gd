class_name Edge
extends RefCounted

var start_index: int
var end_index: int


func _init(start: int, end: int) -> void:
	start_index = start
	end_index = end
