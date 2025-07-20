extends Node2D

@export var context : ContextData
@export var dialogue_manager : DialogueManager

func _ready():
	if not context or not dialogue_manager:
		push_warning("DialogueDisplayer missing dependancies")
		return
	dialogue_manager.dialogue_changed.connect(set_dialogue)
	
func set_dialogue(dialogue : Array[String]):
	pass
