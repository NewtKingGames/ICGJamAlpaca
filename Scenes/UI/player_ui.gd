extends CanvasLayer

@onready var enemy_killed_label: Label = $EnemyKilledCounter/VBoxContainer/EnemyKilledLabel
@onready var base_health_label: Label = $BaseHealthCounter/VBoxContainer/BaseHealthLabel

func _ready() -> void:
	Globals.total_killed_enemies.connect(func(value: int): enemy_killed_label.text = str(value))
	Globals.total_base_health.connect(func(value: int): base_health_label.text = str(value))
