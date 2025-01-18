class_name Pen
extends Node2D


var penned_llama: Llama = null
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_llama_entered)

func _on_llama_entered(body: Node2D) -> void:
	if body is Llama:
		pen_llama(body)

func pen_llama(llama: Llama) -> void:
	penned_llama = llama
	penned_llama.pen(self)
