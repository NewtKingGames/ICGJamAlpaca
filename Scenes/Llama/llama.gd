class_name Llama
extends CharacterBody2D
@onready var flee_enter_area: Area2D = $FleeEnterArea
@onready var flee_exit_area: Area2D = $FleeExitArea

var SPIT_SCENE: PackedScene = preload("res://Scenes/Projectiles/llama_spit.tscn")


@export var wander_speed: float = 100.0
@export var flee_speed: float = 120.0
@export var pen_time: float = 10.0
@export var spit_rate: float = 3.0
@export var spit_speed: float = 60.0

var penned: bool = false
var current_pen: Pen = null

var player: Player

@onready var state_machine: StateMachine = $StateMachine

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	flee_enter_area.body_entered.connect(_on_player_entered)
	flee_enter_area.body_exited.connect(_on_player_exited)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if velocity != Vector2.ZERO:
		# Rotate the llama in the correct direction
		rotation = lerpf(rotation, velocity.angle(), delta)

func get_vector_to_player() -> Vector2:
	print(global_position.direction_to(player.global_position))
	return global_position.direction_to(player.global_position)

func get_position_away_from_player() -> Vector2:
	return -global_position.direction_to(player.global_position) + position

func get_vector_away_from_player() -> Vector2:
	return player.global_position.direction_to(global_position)

func pen(pen: Pen) -> void:
	penned = true
	current_pen = pen
	state_machine.on_outside_transition("penned")

func spit() -> void:
	var spit: LlamaSpit = SPIT_SCENE.instantiate() as LlamaSpit
	spit.rotation = rotation
	spit.direction = Vector2(1,0).rotated(rotation)
	spit.spit_speed = spit_speed
	spit.global_position = global_position
	Events.llama_spit.emit(spit)


func _on_player_entered(body: Node2D) -> void: 
	if body is Player and not penned:
		state_machine.on_outside_transition("flee")

func _on_player_exited(body: Node2D) -> void:
	if body is Player and not penned:
		state_machine.on_outside_transition("idle")
