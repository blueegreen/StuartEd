extends Node2D
class_name MinigameScene

signal minigame_closed

func _end_scene():
	minigame_closed.emit()
	queue_free()
