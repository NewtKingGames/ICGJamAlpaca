extends Node2D
class_name Level

var ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemy/enemy.tscn")

@export var total_number_of_enemies_to_spawn: int
var total_enemies_spawned: int
var total_enemies_died: int
@export var spawn_delay: float
@export var spawn_delay_offset: float

@onready var path_2d: Path2D = $Path2D
# TODO - do you even need this?
#@onready var base_area: Area2D = $BaseArea


func _ready() -> void:
	Events.enemy_entered_base.connect(_on_enemy_entered_base)
	Events.enemy_died.connect(_on_enemy_died)
	spawn_enemy_and_schedule_next_if_can_spawn()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset_level"):
		get_tree().reload_current_scene()

func spawn_enemy_and_schedule_next_if_can_spawn() -> void:
	spawn_enemy()
	if total_enemies_spawned < total_number_of_enemies_to_spawn:
		get_tree().create_timer(spawn_delay + randf_range(-spawn_delay_offset, spawn_delay_offset)).timeout.connect(spawn_enemy_and_schedule_next_if_can_spawn)
	else: 
		print("done")

func spawn_enemy() -> void:
	var enemy: Enemy = ENEMY_SCENE.instantiate() as Enemy
	enemy.progress_ratio = 0
	path_2d.add_child(enemy)
	total_enemies_spawned += 1

func _on_enemy_entered_base(enemy: Enemy) -> void:
	enemy.die()
	Globals.base_health -= 5

func _on_enemy_died() -> void:
	total_enemies_died+=1
	print("total enemies died")
	print(total_enemies_died)
