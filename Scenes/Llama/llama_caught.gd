class_name LlamaCaught
extends LlamaState


func Enter() -> void:
	llama_character.held = true
	print("Llama caught todo - add fun visuals")
	llama_character.disable_collisions()

func Exit() -> void:
	llama_character.held = false
	llama_character.enable_collisions()
