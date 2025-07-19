extends Node2D
class_name ClueBook

@export var start_pos := Vector2(-115, -215)
@export var clue_height := 100.
@export var clue_scene : PackedScene

signal clue_tried(clue: String)

func _ready():
	await get_tree().process_frame
	if GameState.level_state:
		GameState.level_state.clue_changed.connect(_update_clues)
		_setup_clues()
		_update_clues()

func _setup_clues():
	for i in GameState.level_state.clues.size():
		var new_clue : Clue = clue_scene.instantiate()
		new_clue.clue = GameState.level_state.clues[i]
		new_clue.clue_clicked.connect(_on_clue_click)
		new_clue.global_position = start_pos + Vector2(0, 1) * clue_height * i
		add_child(new_clue)
	pass

func _update_clues():
	for child in get_children():
		if child is Clue:
			if GameState.level_state.is_clue_true(child.clue):
				child.activate_clue()

func _on_clue_click(clue: String):
	clue_tried.emit(clue)
