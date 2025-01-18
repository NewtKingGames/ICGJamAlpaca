class_name Llama
extends CharacterBody2D
@onready var flee_enter_area: Area2D = $FleeEnterArea
@onready var flee_exit_area: Area2D = $FleeExitArea

@export var wander_speed: float = 100.0
@export var flee_speed: float = 120.0
@export var pen_time: float = 10.0


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
	#look_at()

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

func _on_player_entered(body: Node2D) -> void: 
	if body is Player and not penned:
		state_machine.on_outside_transition("flee")

func _on_player_exited(body: Node2D) -> void:
	if body is Player and not penned:
		state_machine.on_outside_transition("idle")
