class_name Player
extends CharacterBody2D

@export var player_walk_speed: float = 250.0
@export var sprint_speed: float = 20.0

@onready var llama_grab_area: Area2D = $LlamaGrabArea
@onready var llama_holder_position: Marker2D = $LlamaHolderPosition
@onready var llama_throwing_position: Marker2D = $LlamaThrowingPosition

var held_llama: Llama = null

func _ready() -> void:
	llama_grab_area.body_entered.connect(_on_llama_collision)

func _physics_process(delta: float) -> void:
	# Can only move when not holding llama
	if not held_llama:
		var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity = direction * player_walk_speed
		if velocity == Vector2.ZERO:
			look_at(get_global_mouse_position())
		else:
			look_at(direction + global_position)
		move_and_slide()
	else:
		update_held_llama_position()
		look_at(get_global_mouse_position())
		if Input.is_action_just_released("mouse_click"):
			print("release the llama!")

func _on_llama_collision(body: Node2D) -> void:
	print("detected")
	body = body as Llama
	if body:
		hold_llama(body)

func hold_llama(llama: Llama) -> void:
	if held_llama:
		print("already holding llama!")
		return
	held_llama = llama

func charge_held_llama() -> void:
	print("do nothing for now")

func release_held_llama() -> void:
	held_llama = null

func update_held_llama_position() -> void:
	held_llama.global_position = llama_holder_position.global_position
	held_llama.rotation = rotation
