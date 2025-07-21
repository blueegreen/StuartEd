extends Node

@export var player : AudioStreamPlayer
@export var songs : Array[AudioStreamWAV]

func _ready():
	player.stream = songs[0]
	player.play()

func play_song(id:int):
	if id >= songs.size():
		return
	var fade_tween = create_tween()
	fade_tween.tween_property(player, "volume_db", -50, 2.)
	fade_tween.tween_callback(func(): 
		player.stream = songs[id]
		player.play())
	fade_tween.tween_property(player, "volume_db", -5, 4.)
