extends Area2D

@export var respawn_point : Marker2D

func _on_body_entered(body):
	if respawn_point:
		var dupe = body.duplicate()
		var body_name = body.name
		body.queue_free()
		get_tree().current_scene.call_deferred("add_child", dupe)
		dupe.linear_velocity = Vector2.ZERO
		dupe.angular_velocity = 0
		dupe.name = body_name
		dupe.global_position = respawn_point.global_position
