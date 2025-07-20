extends Node
class_name LevelState

@export var flags: Dictionary = {}
@export var clues: Dictionary = {}
@export var win_flags: Dictionary = {}

signal flag_changed(name: String, value: Variant)
signal clue_changed(name: String, value: Variant)
signal level_won

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
	
	for flag in win_flags:
		if not win_flags[flag]:
			return
	level_won.emit()
