extends EventManager

@export var whack_scene : PackedScene
@export var whirl_scene : PackedScene
@export var screen_scene : PackedScene

func event1():
	start_minigame_event(whack_scene)

func event2():
	start_minigame_event(whirl_scene)

func event3():
	start_minigame_event(screen_scene)

func start_minigame_event(minigame_scene: PackedScene):
	InputManager.set_interaction_paused(true)
	var new_minigame : MinigameScene = minigame_scene.instantiate()
	new_minigame.minigame_closed.connect(event_end)
	call_deferred("add_sibling", new_minigame)

func event_end():
	InputManager.set_interaction_paused(false)
	_event_active = false
