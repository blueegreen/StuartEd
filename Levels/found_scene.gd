extends Node2D
class_name FoundScene

@export var s_spr : Sprite2D
@export var e_spr : Sprite2D

@export var s_lbl : Label
@export var e_lbl : Label

var mode := 0

func _ready():
	match mode:
		0:
			e_spr.visible = false
			e_lbl.visible = false
		1:
			s_spr.visible = false
			s_lbl.visible = false
