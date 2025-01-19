class_name SoundPlayer
extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var sounds: Array[AudioStream] = []
@export var sound_override: float = 0.0

func _ready() -> void:
	if sounds.size() == 0:
		print("SOMETHING WENT WRONG")
		return
	for i in range(sounds.size()):
		if i == 0:
			continue
		print("duplicating this node!")
		var copy_audio_node = audio_stream_player_2d.duplicate()
		add_child(copy_audio_node)
	var index = 0
	for child in get_children():
		child = child as AudioStreamPlayer2D
		child.stream = sounds[index]
		child.volume_db = sound_override
		index+=1

func play_sound() -> void:
	var random_audio: AudioStreamPlayer2D = get_children().pick_random() as AudioStreamPlayer2D
	random_audio.pitch_scale = randf_range(0.9, 1.1)
	random_audio.play()
