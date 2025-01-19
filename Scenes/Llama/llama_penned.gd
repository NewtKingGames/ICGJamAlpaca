class_name Penned
extends LlamaState

var PROGRESS_BAR_SCENE: PackedScene = preload("res://Scenes/UI/llama_progress_bar.tscn")


var progress_bar: LlamaProgressBar
var time_waiting_to_shoot: float = 0.0
var position_to_walk_in_pen: Vector2 = Vector2.ZERO
var moving: bool = true

func Enter() -> void:
	llama_character.llama_low_pitch.pitch_scale = randf_range(0.9, 1.2)
	llama_character.llama_low_pitch.play()
	moving = true
	time_waiting_to_shoot = 0.0
	llama_character.velocity = Vector2.ZERO
	llama_character.penned = true
	position_to_walk_in_pen = llama_character.current_pen.get_llama_penned_position()
	var timer: SceneTreeTimer = get_tree().create_timer(llama_character.pen_time)
	timer.timeout.connect(func(): Transitioned.emit(self, "exitpen"))
	#if progress_bar:
		#progress_bar.queue_free()
	llama_character.llama_progress_bar.visible = true
	llama_character.llama_progress_bar.wait_time = llama_character.pen_time
	llama_character.llama_progress_bar.timer = timer
	#progress_bar = PROGRESS_BAR_SCENE.instantiate() as LlamaProgressBar
	#progress_bar.timer = timer
	#progress_bar.wait_time = llama_character.pen_time
	#add_child(progress_bar)

func Exit() -> void:
	#if progress_bar:
		#progress_bar.queue_free()
	llama_character.llama_progress_bar.visible = false
	llama_character.penned = false


func Physics_Update(delta: float) -> void:
	if llama_character.global_position.distance_to(position_to_walk_in_pen) > 10 and moving:
		llama_character.velocity = llama_character.global_position.direction_to(position_to_walk_in_pen)*llama_character.pen_enter_speed
	else:
		llama_character.velocity = Vector2.ZERO
		#llama_character.look_at(llama_character.current_pen.get_pen_front_position())
		moving = false
		#time_waiting_to_shoot += delta
		#if time_waiting_to_shoot >= llama_character.spit_rate:
			#llama_character.spit()
			#time_waiting_to_shoot=0.0
