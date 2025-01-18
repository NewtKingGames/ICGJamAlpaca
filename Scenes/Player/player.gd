class_name Player
extends CharacterBody2D

@export var player_walk_speed: float = 250.0
@export var player_llama_walk_speed: float = 40.0
@export var sprint_speed: float = 20.0

@onready var llama_grab_area: Area2D = $LlamaGrabArea
@onready var llama_holder_position: Marker2D = $LlamaHolderPosition
@onready var llama_throwing_position: Marker2D = $LlamaThrowingPosition

var held_llama: Llama = null

func _ready() -> void:
	llama_grab_area.body_entered.connect(_on_llama_collision)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	# Move slowly when holding llama
	if held_llama:
		velocity = direction * player_llama_walk_speed
		look_at(get_global_mouse_position())
		update_held_llama_position()
		if Input.is_action_just_released("mouse_click"):
			release_held_llama()
	if not held_llama:
		velocity = direction * player_walk_speed
		if velocity == Vector2.ZERO:
			look_at(get_global_mouse_position())
		else:
			look_at(direction + global_position)
	move_and_slide()
		

func _on_llama_collision(body: Node2D) -> void:
	body = body as Llama
	if body:
		hold_llama(body)

func hold_llama(llama: Llama) -> void:
	if held_llama:
		return
	held_llama = llama
	held_llama.llama_grabbed()

func charge_held_llama() -> void:
	print("do nothing for now")

func release_held_llama() -> void:
	# Put llama in released state
	held_llama.global_position = llama_throwing_position.global_position
	held_llama.rotation = rotation
	held_llama.llama_released()
	held_llama = null

func update_held_llama_position() -> void:
	held_llama.global_position = llama_holder_position.global_position
	held_llama.rotation = rotation
