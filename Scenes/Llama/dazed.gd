class_name Dazed
extends LlamaState


func Enter() -> void:
	print("entered dazed state!!")
	llama_character.dazed = true
	llama_character.confusion_effect.emitting = true
	llama_character.velocity = Vector2.ZERO
	get_tree().create_timer(llama_character.daze_time).timeout.connect(func(): Transitioned.emit(self, "idle"))

func Exit() -> void:
	llama_character.dazed = false
	llama_character.confusion_effect.emitting = false
