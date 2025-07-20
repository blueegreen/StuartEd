extends MinigameScene

func _ready():
	await get_tree().create_timer(1).timeout
	
	var dialogue_script : Array[String] = [\
	"left: that is certainly... odd",\
	"right: I knew it!"\
	]
	GameState.dialogue_manager.start_dialogue(dialogue_script)
	GameState.level_state.set_flag("checked footage", true)
	GameState.level_state.set_clue("glowing object", true)

func _on_back_button_button_down():
	_end_scene()
