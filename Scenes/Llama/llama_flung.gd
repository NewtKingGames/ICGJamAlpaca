extends LlamaState


var fling_current_speed: float

func Enter() -> void:
	# Should play a sound here
	llama_character.flung = true
	fling_current_speed = llama_character.flung_max_speed 

func Exit() -> void:
	llama_character.flung = false
	llama_character.rotation = 0

# Need to settle how long the llama may or may not have collisions... Want to make sure it doesn't try to transition to other states....
# The only state a flung llama should transition to is penned

func Physics_Update(delta: float) -> void:
	# Move with max speed
	llama_character.velocity = fling_current_speed * Vector2(1,0).rotated(llama_character.rotation)
	# Decrement max speed
	fling_current_speed  = clamp(fling_current_speed-5, 0, llama_character.flung_max_speed)
	if fling_current_speed == 0:
		Transitioned.emit(self, "idle")
	# TODO what to do when hit wall
