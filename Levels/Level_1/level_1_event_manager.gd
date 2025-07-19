extends EventManager

var claw_game_scene : PackedScene
var winner_scene : PackedScene
@export var kid : CharacterActor 

func event1():
	_event_active = true
	kid.queue_free()
	pass

func event2():
	_event_active = true
	var new_machine_game : MinigameScene = claw_game_scene.instantiate()
	new_machine_game.minigame_closed.connect(event_end)
	call_deferred("add_sibling", new_machine_game)

func event3():
	_event_active = true
	var new_winner : MinigameScene = winner_scene.instantiate()
	new_winner.minigame_closed.connect(event_end)
	call_deferred("add_sibling", new_winner)

func event_end():
	InputManager.set_interaction_paused(false)
	_event_active = false
