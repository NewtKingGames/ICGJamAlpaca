class_name Enemy
extends PathFollow2D

@onready var collision_shape_2d: CollisionShape2D = $CharacterBody2D/CollisionShape2D

@export var health: int = 1 :
	set(value):
		if health > 0 and value < 0:
			Events.enemy_killed.emit()
			die()
		elif health > 0 and value > 0:
			sprite_2d.play("damage")
		health = value
@export var movement_speed: float = 0.02
@export var damage: int

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var invunlerabilty_timer: Timer = $InvunlerabiltyTimer
@onready var slime_damage_noise: AudioStreamPlayer2D = $SlimeDamageNoise



func _ready() -> void:
	invunlerabilty_timer.timeout.connect(_on_invunlerabilty_timeout)
	sprite_2d.animation_finished.connect(func(): sprite_2d.play("default"))
	Globals.base_killed.connect(func(): movement_speed =0.0)

func _process(delta: float) -> void:
	progress_ratio += movement_speed* delta

func hit(damage: int) -> void:
	slime_damage_noise.pitch_scale = randf_range(0.7, 1.3)
	slime_damage_noise.play()
	sprite_2d.material.set_shader_parameter("progress",1)
	invunlerabilty_timer.start()
	health -= damage

func _on_invunlerabilty_timeout() -> void:
	sprite_2d.material.set_shader_parameter("progress", 0)

func die() -> void:
	Events.enemy_died.emit()
	collision_shape_2d.disabled = true
	sprite_2d.play("death")
	await sprite_2d.animation_finished
	queue_free()
