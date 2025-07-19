extends Actor
class_name CharacterActor

@export var animator : AnimationPlayer

func _ready():
	super()
	z_index = 1

func try_animation(animation_name: String):
	if animator:
		if animator.has_animation(animation_name):
			if animator.get_current_animation() == animation_name and animator.is_playing():
				return
			animator.stop()
			animator.play(animation_name)
