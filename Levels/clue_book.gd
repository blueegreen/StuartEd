extends Node2D
class_name ClueBook

@export var start_pos := Vector2(-107, -217)
@export var clue_height := 100.
@export var clue_scene : PackedScene

signal clue_tried(clue: String)
var _clue_index = 0

func _ready():
	await get_tree().process_frame
	if GameState.level_state:
		GameState.level_state.clue_changed.connect(_update_clues)
		_setup_clues()
		_update_clues()

func _setup_clues():
	for clue in GameState.level_state.clues:
		var new_clue : Clue = clue_scene.instantiate()
		new_clue.clue = clue
		new_clue.clue_clicked.connect(_on_clue_click)
		add_child(new_clue)
	pass

func _update_clues(_clue:= "", _value:= true):
	for child in get_children():
		if child is Clue:
			if GameState.level_state.is_clue_true(child.clue) and not child.activated:
				child.activate_clue()
				child.position = start_pos + Vector2(0, 1) * clue_height * _clue_index
				_clue_index += 1

func _on_clue_click(clue: String):
	clue_tried.emit(clue)
