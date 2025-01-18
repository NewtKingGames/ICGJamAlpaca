extends LlamaState


func Enter() -> void:
	llama_character.velocity = Vector2.ZERO	
	llama_character.penned = true
	get_tree().create_timer(llama_character.pen_time).timeout.connect(func(): Transitioned.emit(self, "exitpen"))

func Exit() -> void:
	llama_character.penned = false
	print("exiting penned state")
