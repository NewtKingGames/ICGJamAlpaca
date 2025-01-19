class_name LlamaCaught
extends LlamaState


func Enter() -> void:
	llama_character.held = true
	llama_character.disable_collisions()
	llama_character.sprite_2d.play("idle_up")
	#llama_character.rotate(deg_to_rad(90))

func Exit() -> void:
	llama_character.held = false
	llama_character.enable_collisions()
