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
var _clue_active := false:
	set(value):
		_clue_active = value
		if clue_book:
			clue_book.set_wave(value)

var _can_advance := true
@onready var _text_box_scene = preload("res://Levels/dialogue_box.tscn")
var text_box : DialogueBox

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
		dialogue_finished.emit(false)
		return

	_current_script = script
	_current_script_index = -1
	_dialogue_active = true
	_clue_active = false
	_next_line()

func _next_line():
	_current_script_index += 1
	
	if text_box:
		text_box.queue_free()

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
	
	if context_data:
		_current_character = context_data.get_speaker(_current_parts[0])
		if _current_character:
			_current_character.try_animation("talk")
	
	#debug
	_show_text_box(_current_parts[0], _current_parts[1])
	#debug


func _unhandled_input(event):
	if event.is_action_pressed("click") and not event.is_echo() and _dialogue_active:
		if _clue_active: #if prompting for clue don't further dialogue unless correct clue input
			_end_dialogue(false)
			return
		if _can_advance:
			_next_line()

func _clue_tried(clue: String):
	if _clue_active:
		if clue == _current_parts[2]:
			_next_line()
		else:
			_end_dialogue(false)

func _end_dialogue(is_success := true):
	if text_box:
		text_box.queue_free()
	if _current_character:
		_current_character.try_animation("idle")
		_current_character = null

	_dialogue_active = false
	_clue_active = false
	await get_tree().process_frame
	dialogue_finished.emit(is_success)

func _show_text_box(source: String, dialogue: String):
	text_box = _text_box_scene.instantiate()
	text_box.line_finished.connect(_on_text_box_finished_displaying)
	add_child(text_box)
	var speaker : Node2D
	if context_data:
		speaker = context_data.get_speaker(source)

	var text_position := Vector2.ZERO
	var head_position := Vector2.INF
	if speaker is Player:
		head_position = speaker.global_position
		text_position = speaker.global_position + Vector2(0, -100)
		speaker.direction = sign(GameState.event_manager.last_clicked_actor.global_position.x - speaker.global_position.x)
	elif speaker is CharacterActor:
		head_position = speaker.global_position
		var offsetx = sign(GameState.player.global_position.x - speaker.global_position.x) * 150
		GameState.player.direction = -sign(offsetx)
		text_position = speaker.global_position + Vector2(offsetx, -100)
	elif speaker == null:
		match source:
			"left":
				text_position = Vector2(-600, 300)
			"right":
				text_position = Vector2(500, 300)
		
	text_box.global_position = text_position
	var is_question = _clue_active
	text_box.display_text(dialogue, is_question, head_position)
	_can_advance = false

func _on_text_box_finished_displaying():
	_can_advance = true
