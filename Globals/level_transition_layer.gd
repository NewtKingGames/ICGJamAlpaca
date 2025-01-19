extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func change_scene(target_scene: PackedScene) -> void:
	var tween_out: Tween = create_tween()
	tween_out.tween_property(color_rect, "color", Color(0, 0, 0, 1), 1.2)
	await tween_out.finished
	await get_tree().create_timer(0.5).timeout
	if target_scene:
		get_tree().change_scene_to_packed(target_scene)
	var tween_in: Tween = create_tween()
	tween_in.tween_property(color_rect, "color", Color(0, 0, 0, 0), 1.2)
