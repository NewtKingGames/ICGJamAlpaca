class_name Projectiles
extends Node


func _ready() -> void:
	Events.llama_spit.connect(_on_spit)


func _on_spit(spit: LlamaSpit) -> void:
	add_child(spit)
