extends Node2D
class_name ParallaxParent

var _start_pos : Vector2
@export var parallax_amount := .005

func _ready():
	_start_pos = global_position

func _process(_delta):
	var mouse_offset = get_global_mouse_position() - _start_pos
	global_position = _start_pos - mouse_offset * parallax_amount
