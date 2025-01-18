class_name Player
extends CharacterBody2D

@export var player_walk_speed: float = 250.0
@export var sprint_speed: float = 20.0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * player_walk_speed
	if velocity == Vector2.ZERO:
		look_at(get_global_mouse_position())
	else:
		look_at(direction + global_position)
	move_and_slide()
