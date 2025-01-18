extends Node
# Globals

signal total_killed_enemies(total: int)
signal total_base_health(total: int)

var enemies_killed: int = 0
var base_health: int = 30

func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	enemies_killed += 1
	total_killed_enemies.emit(enemies_killed)
