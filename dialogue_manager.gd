extends Node2D
class_name Dialogue_Manager

#scripts are to be given in this format: (script, context_data)
#script: ["A: hello", "B: hi: 2"] and so on
#context_data: {A: {"marker":ref, "animatedsprite":ref}, B: {"maker":ref, "animatedsprite":ref}}

var dialogue_box_scene = preload("res://dialogue_box.tscn")
var active_box : RichTextLabel = null
var current_script : Array[String] = []
var current_context : Dictionary = {}
var current_index := 0
var is_dialogue_active := false

signal dialogue_finished

func _input(event):
	if is_dialogue_active and event.is_action_pressed("click") and not event.is_echo():
		_show_next_line()
		get_viewport().set_input_as_handled()

func start_dialogue(script:Array[String], context_data:Dictionary):
	current_script = script
	current_context = context_data
	current_index = 0
	is_dialogue_active = true
	_show_next_line()

func _show_next_line():
	if active_box:
		active_box.queue_free()
		active_box = null

	if current_index >= current_script.size():
		_end_dialogue()
		return
	
	var line = current_script[current_index]
	current_index += 1
	var parts = line.split(":", false, 3)
	if parts.size() < 2:
		_show_next_line()
		return
	
	var text_animation = 0
	var speaker_id = parts[0].strip_edges()
	var text = parts[1].strip_edges()
	if parts.size() > 2:
		text_animation = parts[2].strip_edges().to_int()
		
	var speaker_data : Dictionary = current_context.get(speaker_id)
	if speaker_data == null:
		_show_next_line()
		return
	
	var marker = speaker_data.marker
	
	if speaker_data.has("animator"):
		if speaker_data.animator.has_animation("talk"):
			speaker_data.animator.play("talk")

	active_box = dialogue_box_scene.instantiate()
	active_box.set_custom_text(text, text_animation)
	get_tree().current_scene.add_child(active_box)
	active_box.global_position = marker.global_position
	
	await get_tree().create_timer(2.0).timeout
	if speaker_data.has("animator"):
		if speaker_data.animator.has_animation("idle"):
			speaker_data.animator.play("idle")


func _end_dialogue():
	dialogue_finished.emit()
	is_dialogue_active = false
	if active_box:
		active_box.queue_free()
		active_box = null
