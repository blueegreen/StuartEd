extends Node2D

#accesses all incoming interactions
#starts monologue / dialogue based on interaction and story progress

var is_dialogue_active = false

@export var level_progress : test_level_progress
@export var dialogue_manager : test_Dialogue_Manager
@export var player_dialogue_marker : Marker2D

var dialogue_context : Dictionary

func _ready():
	InputManager.interaction_started.connect(_on_interaction)
	dialogue_context = {"player" : {"marker": player_dialogue_marker}}

func _on_interaction(obj:Node2D):
	match obj.name:
		"A":
			level_progress.talked_to_A = true
		"A2":
			print("hi")
			level_progress.talked_to_A2 = true
		"A3":
			if level_progress.talked_to_A2:
				dialogue_manager.start_dialogue(["player: This is A3: 2", "player: I've talked to A2 already: 1"], dialogue_context)
			else:
				dialogue_manager.start_dialogue(["player: This is A3: 2"], dialogue_context)
			await dialogue_manager.dialogue_finished
			print("yooo")
