extends CanvasLayer

@onready var enemy_killed_label: Label = $EnemyKilledCounter/EnemyKilledLabel
@onready var base_health_label: Label = $BaseHealthCounter/BaseHealthLabel
@onready var level_complete_text: Label = $LevelCompleteText


func _ready() -> void:
	level_complete_text.visible = false
	#TODO - probably need to reset these values?
	base_health_label.text = str(Globals.base_health)
	Globals.total_killed_enemies.connect(func(value: int): enemy_killed_label.text = str(value))
	Globals.total_base_health.connect(func(value: int): 
		base_health_label.text = str(value)
	)
	Events.next_level_loading.connect(_on_level_complete)

func _on_level_complete() -> void:
	level_complete_text.visible = true
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(level_complete_text, "theme_override_colors/font_color", Color("f9ffff"), 0.25)
	tween.tween_property(level_complete_text, "theme_override_colors/font_color", Color("f9ff00"), 0.25)
