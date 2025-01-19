extends Node


signal llama_spit(spit: LlamaSpit)
signal llama_grabbed()
signal llama_released()

signal enemy_died()
signal enemy_killed()
signal enemy_entered_base(enemy: Enemy)

signal shake_screen(apply_shake: float)
