extends EventManager

@export var claw_game_scene : PackedScene
@export var winner_scene : PackedScene
@export var kid : CharacterActor 
@export var flicker_animator : AnimationPlayer
@export var event_animator : AnimationPlayer
@export var lights : Node2D

func event1():
	InputManager.set_interaction_paused(true)
	event_animator.play("event2")
	await event_animator.animation_finished
	flicker_animator.play("flicker")
	event_end()
	pass

func event2():
	InputManager.set_interaction_paused(true)
	lights.visible = false
	var new_machine_game : MinigameScene = claw_game_scene.instantiate()
	new_machine_game.minigame_closed.connect(event_end)
	call_deferred("add_sibling", new_machine_game)

func event3():
	InputManager.set_interaction_paused(true)
	lights.visible = false
	var new_winner : MinigameScene = winner_scene.instantiate()
	new_winner.minigame_closed.connect(event_end)
	call_deferred("add_sibling", new_winner)

func event_end():
	InputManager.set_interaction_paused(false)
	_event_active = false
	lights.visible = true
