extends Node2D
class_name Level

var ENEMY_SCENE: PackedScene = preload("res://Scenes/Enemy/enemy.tscn")

@export var total_number_of_enemies_to_spawn: int
@export var spawn_delay: float
@export var spawn_delay_offset: float


@onready var path_2d: Path2D = $Path2D
# TODO - do you even need this?
#@onready var base_area: Area2D = $BaseArea


func _ready() -> void:
	Events.enemy_entered_base.connect(_on_enemy_entered_base)


func spawn_enemy() -> void:
	# TODO add child to path_2d
	pass

func _on_enemy_entered_base(enemy: Enemy) -> void:
	print("lowering base health")
	enemy.queue_free()
	Globals.base_health -= 5
