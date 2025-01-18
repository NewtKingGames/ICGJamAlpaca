extends CharacterBody2D
class_name EnemyBody

@onready var enemy: Enemy = $".."

func hit(damage: int) -> void:
	enemy.hit(damage)
