extends RigidBody2D
class_name GachaBall

@export var is_stuart := false
@export var stuart_sprite : Sprite2D

func _ready():
	if is_stuart:
		stuart_sprite.frame = 0
	else:
		stuart_sprite.frame = randi_range(1, 3)


func _on_body_entered(_body: Node) -> void:
	if randi_range(0, 1) == 0:
		SfxManager.play_sfx("buzz", -10, true)
