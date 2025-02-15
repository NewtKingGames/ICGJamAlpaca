class_name LlamaProgressBar
extends TextureProgressBar

# The timer should be passed in by the lama
var timer: SceneTreeTimer
var wait_time: float

#func _ready() -> void:
	#timer.time_left
	#timer.wait_timed

func _process(delta: float) -> void:
	if timer:
		value = timer.time_left/wait_time * 100
