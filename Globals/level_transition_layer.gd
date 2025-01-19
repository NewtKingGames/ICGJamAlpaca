extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var game_over_label: Label = $GameOverLabel
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound

func _ready() -> void:
	Globals.base_killed.connect(game_over_screen)


func change_scene(target_scene: PackedScene) -> void:
	var tween_out: Tween = create_tween()
	tween_out.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.2)
	await tween_out.finished
	await get_tree().create_timer(0.5).timeout
	if target_scene:
		get_tree().change_scene_to_packed(target_scene)
	var tween_in: Tween = create_tween()
	tween_in.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.2)
	Events.scene_change.emit()


func game_over_screen() -> void:
	game_over_sound.play()
	game_over_label.visible = true
	Events.shake_screen.emit()
	await get_tree().create_timer(0.5).timeout
	var tween_out: Tween = create_tween()
	tween_out.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.2)
	await tween_out.finished
	await get_tree().create_timer(0.5).timeout
	game_over_label.visible = false
	get_tree().reload_current_scene()
	var tween_in: Tween = create_tween()
	tween_in.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.2)
	Events.scene_change.emit()
