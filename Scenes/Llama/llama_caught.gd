class_name LlamaCaught
extends LlamaState


func Enter() -> void:
	print("Llama caught todo - add fun visuals")
	llama_character.disable_collisions()

func Exit() -> void:
	llama_character.enable_collisions()
