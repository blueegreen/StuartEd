extends Node2D
@onready var panel: Panel = $Panel
@onready var blur: ColorRect = $ColorRect
@onready var button: Button = $Button
@onready var area: Area2D = $Area2D


func _ready():
	blur.visible = false
	panel.visible = false
	button.visible = false
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)
	button.pressed.connect(_on_button_pressed)

func _on_mouse_entered():
	print("Mouse entered area!")  # For debugging
	blur.visible = true
	panel.visible = true
	button.visible = true

func _on_mouse_exited():
	print("Mouse exited area!")  # For debugging
	blur.visible = false
	panel.visible = false
	button.visible = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://dialogue_box.tscn")
