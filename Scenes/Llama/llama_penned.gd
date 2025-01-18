class_name Penned
extends LlamaState


var time_waiting_to_shoot: float = 0.0
var position_to_walk_in_pen: Vector2 = Vector2.ZERO
var moving: bool = true

func Enter() -> void:
	moving = true
	time_waiting_to_shoot = 0.0
	llama_character.velocity = Vector2.ZERO
	llama_character.penned = true
	position_to_walk_in_pen = llama_character.current_pen.get_llama_penned_position()
	get_tree().create_timer(llama_character.pen_time).timeout.connect(func(): Transitioned.emit(self, "exitpen"))

func Exit() -> void:
	llama_character.penned = false


func Physics_Update(delta: float) -> void:
	if llama_character.global_position.distance_to(position_to_walk_in_pen) > 10 and moving:
		llama_character.velocity = llama_character.global_position.direction_to(position_to_walk_in_pen)*llama_character.pen_enter_speed
	else:
		llama_character.velocity = Vector2.ZERO
		llama_character.look_at(llama_character.current_pen.get_pen_front_position())
		moving = false
		#time_waiting_to_shoot += delta
		#if time_waiting_to_shoot >= llama_character.spit_rate:
			#llama_character.spit()
			#time_waiting_to_shoot=0.0
