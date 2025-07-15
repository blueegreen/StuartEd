extends Node2D

#accesses all incoming interactions
#starts monologue / dialogue based on interaction and story progress

var is_dialogue_active = false

@export var level_progress : test_level_progress
@export var player_dialogue_marker : Marker2D

func _ready():
	InputManager.interaction_started.connect(_on_interaction)

func _on_interaction(obj:Node2D):
	match obj.name:
		"A":
			level_progress.talked_to_A = true
		"A2":
			level_progress.talked_to_A2 = true
