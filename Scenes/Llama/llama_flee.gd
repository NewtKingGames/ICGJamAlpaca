class_name LlamaFlee
extends LlamaState

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Physics_Update(delta: float) -> void:
	llama_character.velocity = llama_character.get_vector_away_from_player() * llama_character.flee_speed
