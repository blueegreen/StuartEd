extends Node

var level_state : LevelState
var dialogue_manager : DialogueManager
var event_manager : EventManager
var player : Player

func _ready():
	await get_tree().process_frame
	if not level_state:
		push_warning("No LevelState setup")
	if not dialogue_manager:
		push_warning("No DialogueManager setup")
	if not event_manager:
		push_warning("No EventManager setup")
