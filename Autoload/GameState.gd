extends Node

var level_state : LevelState
var dialogue_manager : DialogueManager
var event_manager : EventManager
var player : Player

var completed_level_id : Array[int] = []
var current_level_id : int = 0

func _ready():
	await get_tree().process_frame
	if not level_state:
		push_warning("No LevelState setup")
	if not dialogue_manager:
		push_warning("No DialogueManager setup")
	if not event_manager:
		push_warning("No EventManager setup")

func set_level_complete():
	var id := current_level_id
	if not completed_level_id.has(id):
		completed_level_id.push_back(id)
