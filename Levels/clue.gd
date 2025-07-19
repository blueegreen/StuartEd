extends Area2D
class_name Clue

var clue : String = "clue_text"
@export var label : Label

signal clue_clicked(clue_id: String)

func _ready():
	visible = false
	collision_layer = 0

func activate_clue():
	label.text = clue
	visible = true
	collision_layer = 1

func _input(event):
	if event.is_action_pressed("click") and not event.is_echo():
		clue_clicked.emit(clue)

func _on_mouse_entered():
	scale = Vector2(1, 1) * 1.1


func _on_mouse_exited():
	scale = Vector2(1, 1)
