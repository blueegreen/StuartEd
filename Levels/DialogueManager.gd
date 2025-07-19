extends Node
class_name DialogueManager

@export var context_data : ContextData
@export var clue_book : ClueBook

signal dialogue_finished

var _current_script : Array[String]
var _current_script_index := -1
var _current_parts : PackedStringArray
var _current_character : CharacterActor
var _dialogue_active := false
var _clue_active := false

#script: ["speaker: dialogue: clue (null default): event (null default)", "event_name", ...]
#if dialogue interrupted / leading to event, emit dialogue_finished


func _ready():
	GameState.dialogue_manager = self
	if not context_data:
		push_warning("no context data for dialogue_manager")
	if not clue_book:
		push_warning("no clue book for dialogue_manager")
	
	await get_tree().process_frame
	if clue_book:
		clue_book.clue_tried.connect(_clue_tried)

func start_dialogue(script: Array[String]):
	if _dialogue_active:
		push_warning("attempted to interrupt dialogue with dialogue in dialogue_manager")
		return

	_current_script = script
	_current_script_index = -1
	_dialogue_active = true
	_clue_active = false
	_next_line()

func _next_line():
	_current_script_index += 1
	
	if _current_character:
		_current_character.try_animation("idle")
		_current_character = null

	if _current_script_index >= _current_script.size():
		_end_dialogue()
		return
	
	var line = _current_script[_current_script_index]
	#max complexity: speaker, dialogue, clue
	#min: event
	#general: speaker, dialogue
	
	_current_parts = line.split(":", false, 4)
	match _current_parts.size():
		1:
			_end_dialogue()
			GameState.event_manager.start_event(_current_parts[0])
			return
		2:
			_clue_active = false
		3:
			_clue_active = true
		_:
			push_warning("unknown format for dialogue given: " + line)
			
	for i in _current_parts.size():
		_current_parts[i] = _current_parts[i].strip_edges()
	
	#speaking time:
	
	_current_character = context_data.get_speaker(_current_parts[0])
	if _current_character:
		_current_character.try_animation("talk")
	
	#debug
	print(_current_parts[0] + ": " + _current_parts[1])
	#debug


func _unhandled_input(event):
	if event.is_action_pressed("click") and not event.is_echo() and _dialogue_active:
		if _clue_active: #if prompting for clue don't further dialogue unless correct clue input
			_end_dialogue(false)
			return
		_next_line()

func _clue_tried(clue: String):
	if _clue_active:
		if clue == _current_parts[2]:
			_next_line()

func _end_dialogue(is_success := true):
	if _current_character:
		_current_character.try_animation("idle")
	_dialogue_active = false
	_clue_active = false
	await get_tree().process_frame
	dialogue_finished.emit(is_success)
