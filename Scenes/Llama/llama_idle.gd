class_name LlamaIdle
extends LlamaState


var time_to_idle: float


func Enter() -> void:
	time_to_idle = randf_range(-1, 1) + llama_character.idle_time
	llama_character.velocity = Vector2.ZERO


func Physics_Update(delta: float) -> void:
	time_to_idle -= delta
	if time_to_idle <= 0:
		Transitioned.emit(self, "wander")
