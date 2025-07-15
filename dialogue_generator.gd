extends Node2D
class_name test_dialogue_generator

#scripts are to be given in this format: (script, context_data)
#script: ["A: hello", "B: hi"] and so on
#context_data: {A: {"marker":ref, "animatedsprite":ref}, B: {"maker":ref, "animatedsprite":ref}}

var dialogue_box_scene = preload("res://dialogue_box.tscn")
var active_box : Node2D = null
var current_script : Array[String] = []
var current_context : Dictionary = {}
var current_index := 0
var is_dialogue_active := false

signal dialogue_finished

func _input(event):
	if is_dialogue_active:
		_show_next_line()
		get_viewport().set_input_as_handled()

func start_dialogue(script:Array, context_data:Dictionary):
	current_script = script
	current_context = context_data
	is_dialogue_active = true

func _show_next_line():
	if active_box:
		active_box.queue_free()
		active_box = null

	if current_index >= current_script.size():
		_end_dialogue()
		return
	
	var line = current_script[current_index]
	current_index += 1
	var parts = line.split(":", false, 2)
	if parts.size() != 2:
		_show_next_line()
		return
	
	var speaker_id = parts[0].strip_edges()
	var text = parts[1].strip_edges()
	
	var speaker_data = current_context.get(speaker_id)
	if speaker_data == null:
		_show_next_line()
		return
	
	var marker = speaker_data.marker
	
	if speaker_data.animator:
		if speaker_data.animator.has_animation("talk"):
			speaker_data.animator.play("talk")

	active_box = dialogue_box_scene.instantiate()
	active_box.set_text(text)
	get_tree().current_scene.add_child(active_box)
	active_box.global_position = marker.global_position
	
	await get_tree().create_timer(2.0).timeout
	if speaker_data.animator:
		if speaker_data.animator.has_animation("idle"):
			speaker_data.animator.play("idle")


func _end_dialogue():
	dialogue_finished.emit()
	is_dialogue_active = false
