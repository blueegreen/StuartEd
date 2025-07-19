extends Node
class_name LevelState

@export var flags: Dictionary = {}
@export var clues: Dictionary = {}
@export var false_at_start := true

signal flag_changed(name: String, value: Variant)
signal clue_changed(name: String, value: Variant)

func _ready():
	GameState.level_state = self
	#if false_at_start:
		#for key in flags:
			#flags[key] = false

func set_flag(flag_name: String, value: Variant):
	if flags.has(flag_name):
		flags[flag_name] = value
		flag_changed.emit(flag_name, value)
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
