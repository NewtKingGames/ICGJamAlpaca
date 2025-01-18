class_name Llama
extends CharacterBody2D
@onready var flee_enter_area: Area2D = $FleeEnterArea
@onready var flee_exit_area: Area2D = $FleeExitArea

var SPIT_SCENE: PackedScene = preload("res://Scenes/Projectiles/llama_spit.tscn")

@export var wander_speed: float = 60.0
@export var flee_speed: float = 120.0
@export var flung_max_speed: float = 900.0
@export var pen_enter_speed: float = 240.0 
@export var pen_time: float = 40
@export var spit_rate: float = 1.5
@export var spit_speed: float = 240.0


var flung: bool = false
var held: bool = false
var penned: bool = false
var current_pen: Pen = null

var player: Player

@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var time_waiting_to_shoot: float = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	flee_enter_area.body_entered.connect(_on_player_entered)
	flee_enter_area.body_exited.connect(_on_player_exited)

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.get_collider()
		if collider is EnemyBody:
			collider.hit(100)
	if velocity != Vector2.ZERO:
		# Rotate the llama in the correct direction
		rotation = lerpf(rotation, velocity.angle(), delta*2)
		
	# Calculate time until next spit attack
	if penned or held:
		time_waiting_to_shoot += delta
		if time_waiting_to_shoot >= spit_rate:
			spit()
			time_waiting_to_shoot=0.0
	else:
		time_waiting_to_shoot = 0.0

func get_vector_to_player() -> Vector2:
	print(global_position.direction_to(player.global_position))
	return global_position.direction_to(player.global_position)

func get_position_away_from_player() -> Vector2:
	return -global_position.direction_to(player.global_position) + position

func get_vector_away_from_player() -> Vector2:
	return player.global_position.direction_to(global_position)

func pen(pen: Pen) -> void:
	if not held and not penned:
		penned = true
		current_pen = pen
		state_machine.on_outside_transition("penned")

func spit() -> void:
	var spit: LlamaSpit = SPIT_SCENE.instantiate() as LlamaSpit
	spit.rotation = rotation
	spit.direction = Vector2(1,0).rotated(rotation)
	spit.spit_speed = spit_speed
	spit.global_position = global_position + spit.direction * 70
	Events.llama_spit.emit(spit)

func _on_player_entered(body: Node2D) -> void: 
	if body is Player and not penned and not flung:
		state_machine.on_outside_transition("flee")

func _on_player_exited(body: Node2D) -> void:
	if body is Player and not penned and not flung:
		state_machine.on_outside_transition("idle")

func llama_grabbed() -> void:
	state_machine.on_outside_transition("caught")

func llama_released() -> void:
	state_machine.on_outside_transition("flung")

func disable_collisions() -> void:
	collision_shape_2d.disabled = true

func enable_collisions() -> void:
	collision_shape_2d.disabled = false
