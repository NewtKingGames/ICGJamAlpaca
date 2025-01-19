class_name Player
extends CharacterBody2D

@export var player_walk_speed: float = 400.0
@export var player_llama_walk_speed: float = 40.0
@export var sprint_speed: float = 20.0

@onready var llama_grab_area: Area2D = $LlamaGrabArea
@onready var llama_holder_position: Marker2D = $LlamaHolderPosition
@onready var llama_throwing_position: Marker2D = $LlamaThrowingPosition
@onready var animated_sprite_2d: AnimatedSprite2D = $VisibleNodes/AnimatedSprite2D
@onready var visible_nodes: Node2D = $VisibleNodes
@onready var hands: AnimatedSprite2D = $Hands
@onready var sound_player: SoundPlayer = $SoundPlayer

var previous_velocity: Vector2 = Vector2(1, 0)

var held_llama: Llama = null

var can_play_walk_noise: bool = true: 
	set(value):
		if value == can_play_walk_noise:
			return
		if value == false:
			get_tree().create_timer(0.5).timeout.connect(func(): can_play_walk_noise = true)
		can_play_walk_noise = value

func _ready() -> void:
	llama_grab_area.body_entered.connect(_on_llama_collision)

func _physics_process(delta: float) -> void:
	if velocity.x > 0 and previous_velocity.x < 0:
		animated_sprite_2d.flip_h = false
	if velocity.x < 0 and previous_velocity.x > 0:
		animated_sprite_2d.flip_h = true
	# only set previous velocity to nonzero x values
	if velocity.x != 0:
		previous_velocity = velocity
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	# Move slowly when holding llama
	if held_llama:
		animated_sprite_2d.play("idle_up")
		# Play the idle animation?
		velocity = direction * player_llama_walk_speed
		look_at(get_global_mouse_position())
		update_held_llama_position()
		if Input.is_action_just_released("mouse_click"):
			release_held_llama()
	if not held_llama:
		rotation = 0
		velocity = direction * player_walk_speed
		if velocity != Vector2.ZERO and can_play_walk_noise:
			sound_player.play_sound()
			can_play_walk_noise = false
		play_proper_animation(velocity)
		#if velocity == Vector2.ZERO:
			#look_at(get_global_mouse_position())
		#else:
		#look_at(direction + global_position)
	move_and_slide()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("pause"):
		#if Engine.time_scale == 0:
			#Engine.time_scale = 1
		#else:
			#Engine.time_scale = 0

func _on_llama_collision(body: Node2D) -> void:
	body = body as Llama
	if body:
		hold_llama(body)

func hold_llama(llama: Llama) -> void:
	# Can't grab a llam if we already have one and can't grab a dazed llama
	if held_llama or llama.dazed:
		return
	held_llama = llama
	held_llama.llama_grabbed()
	Events.llama_grabbed.emit()
	# SUPER NASY CODE BUT OH WELL
	animated_sprite_2d.rotation = deg_to_rad(90)
	hands.visible = true

func charge_held_llama() -> void:
	pass

func release_held_llama() -> void:
	# Put llama in released state
	held_llama.global_position = llama_throwing_position.global_position
	held_llama.rotation = rotation
	held_llama.llama_released()
	held_llama = null
	Events.llama_released.emit()
	# SUPER NASY CODE BUT OH WELL
	animated_sprite_2d.rotation = 0
	hands.visible = false

func update_held_llama_position() -> void:
	held_llama.global_position = llama_holder_position.global_position
	held_llama.rotation = rotation + deg_to_rad(90)

func play_proper_animation(velocity: Vector2) -> void:
	# We need to save our previous non zero velocity
	#if velocity
	if velocity.x != 0:
		animated_sprite_2d.play("walk_side")
	elif velocity.y > 0:
		animated_sprite_2d.play("walk_down")
	elif velocity.y < 0:
		animated_sprite_2d.play("walk_up")
	if velocity == Vector2.ZERO:
		var current_animation:String = animated_sprite_2d.animation
		if current_animation == "walk_side":
			animated_sprite_2d.play("idle_side")
		if current_animation == "walk_down":
			animated_sprite_2d.play("idle_down")
		if current_animation == "walk_up":
			animated_sprite_2d.play("idle_up")
