class_name Penned
extends LlamaState


var time_waiting_to_shoot: float = 0.0

func Enter() -> void:
	llama_character.spit()
	time_waiting_to_shoot = 0.0
	llama_character.velocity = Vector2.ZERO	
	llama_character.penned = true
	get_tree().create_timer(llama_character.pen_time).timeout.connect(func(): Transitioned.emit(self, "exitpen"))

func Exit() -> void:
	llama_character.penned = false
	print("exiting penned state")


func Physics_Update(delta: float) -> void:
	time_waiting_to_shoot += delta
	if time_waiting_to_shoot >= llama_character.spit_rate:
		llama_character.spit()
		time_waiting_to_shoot=0.0
