class_name Enemy
extends PathFollow2D

@export var health: int
@export var movement_speed: float
@export var damage: int
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var invunlerabilty_timer: Timer = $InvunlerabiltyTimer



func _ready() -> void:
	invunlerabilty_timer.timeout.connect(_on_invunlerabilty_timeout)
	get_tree().create_timer(1.5).timeout.connect(func(): 
		sprite_2d.material.set_shader_parameter("progress", 1)
		invunlerabilty_timer.start()
	)

func _process(delta: float) -> void:
	progress_ratio +=0.02 * delta


func hit(damage: int) -> void:
	print("thing go thit")
	sprite_2d.material.set_shader_parameter("progress",1)
	invunlerabilty_timer.start()

func _on_invunlerabilty_timeout() -> void:
	sprite_2d.material.set_shader_parameter("progress", 0)
