extends Node


@export var audio_player: AudioStreamPlayer
@export var scene_music: Dictionary[PackedScene, AudioStream]
@export var default_music: AudioStream
@export var no_music_scenes: Array[PackedScene]
@export var persistence_rules_keys: Array[PackedScene]
@export var persistence_rules_values: Array[Array] #keep in mind its Array[Array[PackedScene]]
#but godot doesnt allow this is kinda sad

var _current_scene: PackedScene = null
var _persistence_rules: Dictionary = {}

func _ready():
	for i in persistence_rules_keys.size():
		if i < persistence_rules_values.size():
			_persistence_rules[persistence_rules_keys[i]] = persistence_rules_values[i]

func play_music_for_scene(scene: PackedScene) -> void:
	if scene in no_music_scenes:
		audio_player.stop()
		_current_scene = scene
		return

	if _current_scene and _should_persist_music(_current_scene, scene):
		_current_scene = scene
		return

	_current_scene = scene

	var music: AudioStream = scene_music.get(scene, default_music)
	if music:
		audio_player.stream = music
		audio_player.play()
	else:
		audio_player.stop()

func _should_persist_music(from_scene: PackedScene, to_scene: PackedScene) -> bool:
	if from_scene in _persistence_rules:
		return to_scene in _persistence_rules[from_scene]
	return false
