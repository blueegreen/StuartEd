extends RigidBody2D
class_name GachaBall

@export var is_stuart := false
@export var stuart_sprite : Sprite2D

func _ready():
	if is_stuart:
		stuart_sprite.frame = 0
	else:
		stuart_sprite.frame = randi_range(1, 3)
