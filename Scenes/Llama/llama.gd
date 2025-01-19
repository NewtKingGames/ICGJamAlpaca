class_name Llama
extends CharacterBody2D
@onready var flee_enter_area: Area2D = $FleeEnterArea
@onready var flee_exit_area: Area2D = $FleeExitArea

var SPIT_SCENE: PackedScene = preload("res://Scenes/Projectiles/llama_spit.tscn")

enum SPIT_MODE_ENUM {ALWAYS, PENNED, GRABBED, PENNED_AND_GRABBED}

@export var spit_mode: SPIT_MODE_ENUM = SPIT_MODE_ENUM.PENNED_AND_GRABBED
@export var idle_time: int = 4 

@export var wander_speed: float = 60.0
@export var flee_speed: float = 120.0
@export var flung_max_speed: float = 900.0
@export var pen_enter_speed: float = 240.0 
@export var pen_time: float = 10
@export var spit_rate: float = 1.5
@export var spit_speed: float = 240.0


@onready var sprite_2d: AnimatedSprite2D = $VisibleNodes/Sprite2D



var flung: bool = false
var held: bool = false
var penned: bool = false
var current_pen: Pen = null

var player: Player

@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var visible_nodes: Node2D = $VisibleNodes


var time_waiting_to_shoot: float = 0

# have to track when the enemy flipped rather than setting the scale to -x everytime
var previous_velocity: Vector2 = Vector2(1,0)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	flee_enter_area.body_entered.connect(_on_player_entered)
	flee_enter_area.body_exited.connect(_on_player_exited)

func _physics_process(delta: float) -> void:
	# Control flipping of sprite
	if velocity.x > 0 and previous_velocity.x < 0:
		visible_nodes.scale.x = 1
	if velocity.x < 0 and previous_velocity.x > 0:
		visible_nodes.scale.x = -1
	
	# only set previous velocity to nonzero x values
	if velocity.x != 0:
		previous_velocity = velocity
	
	var collision: KinematicCollision2D = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.get_collider()
		if collider is EnemyBody:
			collider.hit(100)
	#if velocity != Vector2.ZERO:
		## Rotate the llama in the correct direction
		#rotation = lerpf(rotation, velocity.angle(), delta*2)
		
	handle_spit_frame(delta)
		
	# Basic animation controller
	# First we'll do if moving
	if not penned and not held:
		if velocity.x != 0:
			sprite_2d.play("walk_side")
		elif velocity.y > 0:
			sprite_2d.play("walk_down")
		elif velocity.y < 0:
			sprite_2d.play("walk_up")
	if velocity == Vector2.ZERO and not penned and not held:
		var current_animation:String = sprite_2d.animation
		if current_animation == "walk_side":
			sprite_2d.play("idle_side")
		if current_animation == "walk_down":
			sprite_2d.play("idle_down")
		if current_animation == "walk_up":
			sprite_2d.play("idle_up")
	# Then we'll do if not moving

func handle_spit_frame(delta: float) -> void:
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
		print("we penned up")
		print(pen.look_direction)
		match pen.look_direction: 
			Pen.LOOK_DIRECTION.UP:
				sprite_2d.play("idle_up")
			Pen.LOOK_DIRECTION.DOWN:
				sprite_2d.play("idle_down")
			Pen.LOOK_DIRECTION.LEFT:
				sprite_2d.play("idle_side")
			Pen.LOOK_DIRECTION.RIGHT:
				sprite_2d.play("idle_side")

func spit() -> void:
	var spit: LlamaSpit = SPIT_SCENE.instantiate() as LlamaSpit
	spit.rotation = get_spit_rotation()
	spit.direction = get_spit_direction()
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

func get_spit_rotation() -> float:
	if penned:
		match current_pen.look_direction: 
			Pen.LOOK_DIRECTION.UP:
				return Vector2.UP.angle()
			Pen.LOOK_DIRECTION.DOWN:
				return Vector2.DOWN.angle()
			Pen.LOOK_DIRECTION.LEFT:
				return Vector2.LEFT.angle()
			Pen.LOOK_DIRECTION.RIGHT:
				return Vector2.RIGHT.angle()
			_:
				return Vector2.ZERO.angle()
	else:
		return rotation-deg_to_rad(90)

func get_spit_direction() -> Vector2:
	if penned:
		match current_pen.look_direction: 
			Pen.LOOK_DIRECTION.UP:
				return Vector2.UP
			Pen.LOOK_DIRECTION.DOWN:
				return Vector2.DOWN
			Pen.LOOK_DIRECTION.LEFT:
				return Vector2.LEFT
			Pen.LOOK_DIRECTION.RIGHT:
				return Vector2.RIGHT
			_:
				return Vector2.ZERO
	else:
		return Vector2(0,1).rotated(rotation+deg_to_rad(180))
