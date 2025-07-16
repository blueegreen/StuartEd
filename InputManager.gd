extends Node

signal interaction_started(target)
signal mouse_released()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click") and not event.is_echo():
			_process_click(event.position)
		elif event.is_action_released("click"):
			mouse_released.emit()

func _process_click(position):
	var space_state = get_viewport().get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	var result = space_state.intersect_point(query)
	if result.size() > 0:
		var top = result[0].collider
		for n in result:
			if n.collider.z_index > top.z_index or n.collider.get_index() > top.get_index():
				top = n.collider
		interaction_started.emit(top)
