class_name ExitPen
extends LlamaState

var destination_vector: Vector2

# when a llama exits a pen it needs to grab a point on the map to wander to before transitioning to idle
# It should be able to be corralled almost immediately though
func Enter() -> void:
	if not llama_character.current_pen:
		Transitioned.emit(self, "idle")
	else:
		destination_vector = llama_character.current_pen.get_llama_exit_position()
	

func Physics_Update(delta: float) -> void:
	llama_character.velocity = llama_character.global_position.direction_to(destination_vector) * llama_character.wander_speed
	if llama_character.global_position.distance_to(destination_vector) < 10.0:
		Transitioned.emit(self, "idle")
