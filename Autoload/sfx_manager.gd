extends Node

#@export var sfx_names: Array[String] = []
#@export var sfx_streams: Array[AudioStream] = []
@export var sfx: Dictionary[String,AudioStream]


var active_players: Array[AudioStreamPlayer] = []

func _ready():
	return
	#if sfx_names.size() != sfx_streams.size():
		#push_error("SFXManager: 'sfx_names' and 'sfx_streams' must have the same length!")

func play_sfx(sfx_name: String, volume_db := 0.0, randomised_pitch := false,  playback_start := 0.0):
	var index = sfx.keys().find(sfx_name)
	if index == -1:
		print("SFXManager: Sound not found - ", sfx_name)
		return
	
	var stream = sfx[sfx_name]
	if stream == null:
		print("SFXManager: Null stream for name - ", sfx_name)
		return

	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = randf_range(.75, 1.2) if randomised_pitch else 1.0
	add_child(player)
	player.play(playback_start)
	player.connect("finished", Callable(player, "queue_free"))
	active_players.append(player)
