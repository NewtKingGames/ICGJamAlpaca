extends CharacterBody2D

@onready var enemy: Enemy = $".."

func hit(damage: int) -> void:
	enemy.hit(damage)
