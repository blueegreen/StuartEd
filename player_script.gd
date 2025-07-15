extends CharacterBody2D

var movement_speed := 100.
var jump_height := 110.
var gravity := 980.

func _process(delta):
	var dir = Input.get_axis("left", "right")
	velocity.x = dir * movement_speed
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -sqrt(2 * gravity * jump_height)
		print(velocity.y)
	velocity.y += gravity * delta
	move_and_slide()
	velocity.x = clampf(velocity.x, -movement_speed, movement_speed)
	velocity.y = clampf(velocity.y, -sqrt(2 * gravity * jump_height), sqrt(2 * gravity * jump_height))
