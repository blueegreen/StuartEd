extends Node2D
class_name test_dialogue_generator

#scripts are to be given in this format: (script, context_data)
#script: ["A: hello", "B: hi"] and so on
#context_data: {A: {"marker":ref, "animatedsprite":ref}, B: {"maker":ref, "animatedsprite":ref}}

var dialogue_box = preload("res://dialogue_box.tscn")
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
	if current_index >= current_script.size():
		_end_dialogue()
		return
	

func _end_dialogue():
	dialogue_finished.emit()
	is_dialogue_active = false
