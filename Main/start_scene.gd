extends Node2D

@export var cutscene_animator : AnimationPlayer
@export var play_button : Button

func _on_button_button_down():
	play_button.disabled = true
	if GameState.cutscene_viewed:
		get_tree().change_scene_to_file("res://Main/new_level_selector.tscn")
	else:
		GameState.cutscene_viewed = true
		cutscene_animator.play("cutscene")
		await cutscene_animator.animation_finished
		get_tree().change_scene_to_file("res://Main/new_level_selector.tscn")
