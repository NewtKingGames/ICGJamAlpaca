class_name LlamaIdle
extends LlamaState


var time_to_idle: float


func Enter() -> void:
	time_to_idle = randf_range(5, 9)
	llama_character.velocity = Vector2.ZERO


func Physics_Update(delta: float) -> void:
	time_to_idle -= delta
	if time_to_idle <= 0:
		Transitioned.emit(self, "wander")
