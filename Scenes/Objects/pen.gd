class_name Pen
extends Node2D


enum LOOK_DIRECTION {LEFT, UP, RIGHT, DOWN}

@export var look_direction: LOOK_DIRECTION = LOOK_DIRECTION.UP
var penned_llama: Llama = null
@onready var area_2d: Area2D = $Area2D
@onready var pen_center: Marker2D = $PenCenter
@onready var pen_front: Marker2D = $PenFront

func _ready() -> void:
	area_2d.body_entered.connect(_on_llama_entered)
	area_2d.body_exited.connect(_on_llama_exited)

func _on_llama_entered(body: Node2D) -> void:
	if body is Llama and penned_llama == null:
		pen_llama(body)

func _on_llama_exited(body: Node2D) -> void:
	if body is Llama and body == penned_llama:
		#Unpen lama
		penned_llama = null

func pen_llama(llama: Llama) -> void:
	penned_llama = llama
	penned_llama.pen(self)

func get_llama_exit_position() -> Vector2:
	return $PenFront.global_position + Vector2.LEFT.rotated(rotation).normalized()*600;

func get_llama_penned_position() -> Vector2:
	return pen_center.global_position;

func get_pen_front_position() -> Vector2:
	return pen_front.global_position;
