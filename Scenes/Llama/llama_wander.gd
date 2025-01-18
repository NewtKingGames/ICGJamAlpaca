class_name LlamaWander
extends LlamaState

var direction: Vector2
var time_to_idle: float

func Enter() -> void:
	var first_number: int = randi_range(0, 1)
	# Sets the second number to either 1 or 0 depending on what first number
	var second_number: int = first_number + 1 % 2
	direction = Vector2(first_number, second_number)
	print("direction is")
	print(direction)
	#llama_character.rotation = direction.angle()
	time_to_idle = randf_range(1, 2.8)

func Physics_Update(delta: float) -> void:
	llama_character.velocity = direction * llama_character.wander_speed
	time_to_idle -= delta
	if time_to_idle <= 0:
		Transitioned.emit(self, "idle")
