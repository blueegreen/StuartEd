extends Node2D
class_name Actor

@export var interaction_resource: ActorInteractionResource

func _ready():
	await get_tree().process_frame
	InputManager.interaction_started.connect(_on_click)
	if GameState.level_state:
		GameState.level_state.flag_changed.connect(_set_own_state)
	pass

func _set_own_state():
	pass

func _on_click(target: Node2D):
	if target != self or interaction_resource == null:
		return

	var best_entry: InteractionEntry = null
	var best_score := -1

	for entry in interaction_resource.interactions:
		var matching_entry := true
		for flag_name in entry.required_flags:
			if GameState.level_state.is_flag_true(flag_name) != entry.required_flags[flag_name]:
				matching_entry = false
				break
		if matching_entry:
			var score := entry.required_flags.size()
			if score > best_score:
				best_entry = entry
				best_score = score

	if best_entry:
		GameState.event_manager.start_dialogue_event(self, best_entry)
	else:
		push_warning("no appropriate interaction found for: " + name)

	
	#For simple dialogue, simple do:
	#GameState.event_manager.start_dialogue_event(self, dialogue:Array[String], should_walk:=true)
	
	#For other events, do:
	#GameState.event_manager.start_event(event_name:String) 
