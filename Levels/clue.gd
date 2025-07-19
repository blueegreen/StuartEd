extends Button
class_name Clue

var clue : String = "clue_text"
var activated = false
@export var label : Label

signal clue_clicked(clue_id: String)

func _ready():
	visible = false
	disabled = true

func activate_clue():
	label.text = clue
	visible = true
	disabled = false
	activated = true

func _on_mouse_entered():
	scale = Vector2(1, 1) * 1.1


func _on_mouse_exited():
	scale = Vector2(1, 1)

#func _on_input_event(_viewport, event, _shape_idx):
	#if event.is_action_pressed("click") and not event.is_echo():
		#clue_clicked.emit(clue)
		#get_viewport().set_input_as_handled()

func _on_button_down():
	clue_clicked.emit(clue)
	#get_viewport().set_input_as_handled()
