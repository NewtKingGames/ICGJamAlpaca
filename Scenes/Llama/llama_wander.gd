class_name LlamaWander
extends LlamaState

var direction: Vector2
var time_to_idle: float

func Enter() -> void:
	direction = Vector2(Utils.get_one_or_negative_one(), Utils.get_one_or_negative_one())
	#llama_character.rotation = direction.angle()
	time_to_idle = randf_range(2, 4)

func Physics_Update(delta: float) -> void:
	#llama_character.velocity = Vector2.UP * llama_character.wander_speed
	# look away from the player
	#print("this objects rotation")
	#llama_character.rotation = rotate_toward(llama_character.rotation, llama_character.get_vector_to_player().angle(), delta)
	#llama_character.rotation = llama_character.position.angle_to_point()
	llama_character.velocity = direction * llama_character.wander_speed
	time_to_idle -= delta
	if time_to_idle <= 0:
		Transitioned.emit(self, "idle")
	# Move this code to flee
	#llama_character.look_at(llama_character.get_position_away_from_player())
