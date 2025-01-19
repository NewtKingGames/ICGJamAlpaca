extends Node
# Globals

signal total_killed_enemies(total: int)
signal total_base_health(total: int)
signal base_killed

var enemies_killed: int = 0
var base_health: int = 30 :
	set(value):
		if value < 0:
			return
		if value == 0:
			print("ending level!")
			base_killed.emit()
		base_health = value
		total_base_health.emit(base_health)

func _ready() -> void:
	Events.enemy_killed.connect(_on_enemy_killed)
	Events.scene_change.connect(_on_scene_change)

func _on_enemy_killed() -> void:
	enemies_killed += 1
	total_killed_enemies.emit(enemies_killed)

func _on_scene_change() -> void:
	base_health = 30
	enemies_killed = 0
	total_killed_enemies.emit(enemies_killed)
