class_name Pen
extends Node2D


var penned_llama: Llama = null
@onready var area_2d: Area2D = $Area2D
@onready var pen_center: Marker2D = $PenCenter
@onready var pen_front: Marker2D = $PenFront

func _ready() -> void:
	area_2d.body_entered.connect(_on_llama_entered)

func _on_llama_entered(body: Node2D) -> void:
	if body is Llama:
		pen_llama(body)

func pen_llama(llama: Llama) -> void:
	penned_llama = llama
	penned_llama.pen(self)

func get_llama_exit_position() -> Vector2:
	return $PenFront.global_position + Vector2.LEFT.rotated(rotation).normalized()*600;

func get_llama_penned_position() -> Vector2:
	return pen_center.global_position;

func get_pen_front_position() -> Vector2:
	return pen_front.global_position;
