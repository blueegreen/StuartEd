extends Node
class_name EventManager

var _event_active := false

func _ready():
	GameState.event_manager = self

func start_event(event_name: String):
	if self.has_method(event_name):
		self.call_deferred(event_name)
	else:
		push_warning("No such event method: %s" % event_name)


#check based on level_state if successful interaction - if so, call player to move, and wait for player to reach correct point
#remember to pause interaction until entire interaction has finished
#hierarchy: interaction start -> await walk -> dialogue start / event -> dialogue / event end -> interaction end

#func start_dialogue_event(actor: Actor, dialogue: Array[String], walk_required: bool = true):
func start_dialogue_event(actor: Actor, interaction: InteractionEntry):
	if _event_active:
		push_warning("dialogue attempted to be interrupted by dialogue")
		return
	
	_event_active = true
	InputManager.set_interaction_paused(true)
	
	if interaction.walk_required:
		GameState.player.walk_to_actor(actor)
		await GameState.player.finished_walk
	
	GameState.dialogue_manager.start_dialogue(interaction.dialogue)
	await GameState.dialogue_manager.dialogue_finished
	
	for flag in interaction.flags_triggered:
		GameState.level_state.set_flag(flag, true)
	for clue in interaction.clues_triggered:
		GameState.level_state.set_clue(clue, true)

	InputManager.set_interaction_paused(false)
	_event_active = false
