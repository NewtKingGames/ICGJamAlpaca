class_name LlamaSpit
extends Node2D

@onready var area_2d: Area2D = $Area2D

var spit_speed: float = 100
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction*spit_speed*delta

func _on_body_entered(body: Node2D) -> void:
	print("hit something")
	if body is Player:
		print("hit player!")
	else:
		print("about to hit body")
		body.hit(3) # TODO - include damage!!!!
	queue_free()
