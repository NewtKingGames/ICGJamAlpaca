extends Node


func get_one_or_negative_one() -> int:
	if randi_range(0, 1) == 0:
		return -1
	else:
		return 1
