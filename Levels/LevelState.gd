extends Node
class_name LevelState

@export var flags: Dictionary = {}
@export var clues: Dictionary = {}
@export var win_flags: Dictionary = {}

signal flag_changed(name: String, value: Variant)
signal clue_changed(name: String, value: Variant)
signal level_won

var found_scene : PackedScene = preload("res://Levels/found_scene.tscn")

func _ready():
	GameState.level_state = self

func set_flag(flag_name: String, value: Variant):
	if flags.has(flag_name):
		flags[flag_name] = value
		flag_changed.emit(flag_name, value)
		
		_set_win_flag(flag_name, value)
		
	else:
		push_warning("%s: No flag named '%s'" % [get_path(), flag_name])

func is_flag_true(flag_name: String) -> bool:
	if flags.has(flag_name):
		return bool(flags[flag_name])
	push_warning("%s: No flag named '%s'" % [get_path(), flag_name])
	return false

func set_clue(clue_name: String, value: Variant):
	if clues.has(clue_name):
		clues[clue_name] = value
		clue_changed.emit(clue_name, value)
	else:
		push_warning("%s: No clue named '%s'" % [get_path(), clue_name])

func is_clue_true(clue_name: String) -> bool:
	if clues.has(clue_name):
		return bool(clues[clue_name])
	push_warning("%s: No clue named '%s'" % [get_path(), clue_name])
	return false

func _set_win_flag(flag_name: String, value: bool):
	if win_flags.has(flag_name):
		win_flags[flag_name] = value
	
	if win_flags.has(flag_name) and value:
		var id := 0
		match(flag_name):
			"stuart found":
				id = 0
			"ed found":
				id = 1
		var new_found_scene : FoundScene = found_scene.instantiate()
		new_found_scene.mode = id
		get_tree().root.add_child(new_found_scene)
		SfxManager.play_sfx("win")
	
	for flag in win_flags:
		if not win_flags[flag]:
			return
	level_won.emit()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Main/new_level_selector.tscn")
