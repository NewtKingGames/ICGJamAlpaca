extends Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyBody:
		Events.enemy_entered_base.emit(body.get_enemy())
		audio_stream_player.play()
