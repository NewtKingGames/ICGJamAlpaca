class_name LlamaWander
extends LlamaState

var direction: Vector2
var time_to_idle: float
var wander_directions: Array[Vector2] = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]


func Enter() -> void:
	direction = wander_directions[randi_range(0, 3)]
	#llama_character.rotation = direction.angle()
	time_to_idle = randf_range(1, 2.8)

func Physics_Update(delta: float) -> void:
	llama_character.velocity = direction * llama_character.wander_speed
	time_to_idle -= delta
	if time_to_idle <= 0:
		Transitioned.emit(self, "idle")
