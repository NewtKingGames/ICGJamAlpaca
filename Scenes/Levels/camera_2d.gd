extends Camera2D


# TODO - add juice for

# - shake the camera slightly when you get hit by llama spit
# - shake camera when slime get's through the path
# - zoom in camera when holding a llama (maybe some shake too?)

@export var random_strength: float = 80
@export var shake_fade: float = 8
@export var typing_zoom_rate: float = 5

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0
var player: Player
var camera_target_zoom: Vector2 = zoom
var camera_target_position: Vector2 = Vector2.ZERO


func _ready():
	player = get_tree().get_first_node_in_group("player")
	Events.shake_screen.connect(apply_shake)
	#player.connect("slowdown_effect_entered", on_slowdown_effect_entered)
	#player.connect("slowdown_effect_exited", on_slowdown_effect_exited)
	Events.llama_grabbed.connect(on_llama_grabbed)
	Events.llama_released.connect(on_llama_released)
	#Events.current_string_typed.connect(apply_shake_small)

func _process(delta):
	# Shake camera when player is damaged
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade*delta)
	# Zoom camera in when player is spelling
	if zoom != camera_target_zoom:
		# TODO - decide if you want to continue to use tweens here and if so delete the unneccessary code
		var zoom_tween: Tween = create_tween()
		zoom_tween.tween_property(self, "zoom", camera_target_zoom, 3)
		#zoom.x = lerpf(zoom.x, camera_target_zoom.x, typing_zoom_rate*delta)
		#zoom.y = lerpf(zoom.y, camera_target_zoom.y, typing_zoom_rate*delta)
	if position != camera_target_position:
		#position = lerp(position, camera_target_position, delta*5)
		var pos_tween: Tween = create_tween()
		pos_tween.tween_property(self, "position", camera_target_position, 1.5)
	offset = random_offset()


func apply_shake(strength:float = 80):
	shake_strength = strength

func apply_shake_small(string: String):
	shake_strength = 0.6

func on_llama_grabbed():
	camera_target_zoom = Vector2(0.9, 0.9)
	camera_target_position = player.global_position / 1.5
	
func on_llama_released():
	camera_target_zoom = Vector2(0.7, 0.7)
	camera_target_position = Vector2.ZERO
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
