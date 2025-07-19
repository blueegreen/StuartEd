extends MinigameScene

signal ed_found
@export var button : Button
@export var animation_player : AnimationPlayer

func _ready():
	if GameState.level_state:
		if GameState.level_state.is_flag_true("kid left"):
			animation_player.play("flicker")
			button.set_disabled(false)

func _on_button_toggled(_toggled_on):
	ed_found.emit()
	if GameState.level_state:
		GameState.level_state.set_flag("ed found", true)


func _on_back_button_toggled(_toggled_on):
	_end_scene()
