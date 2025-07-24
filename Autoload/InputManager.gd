extends Node2D

signal interaction_started(target)
signal mouse_released()

var interaction_paused := false

func _ready():
	get_tree().scene_changed.connect(_reset)

func _unhandled_input(event):
	if event.is_action_pressed("click") and not event.is_echo() and not interaction_paused:
		if _process_click():
			get_viewport().set_input_as_handled()
	elif event.is_action_released("click"):
		mouse_released.emit()

func _process_click():
	var space_state = get_viewport().get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_point(query)
	if result.size() > 0:
		var top = _get_topmost_collider(result)
		print(top.name, " clicked")
		interaction_started.emit(top)
		if not top is Actor:
			push_warning("non-actor clicked: " + top.name)
		return true
	return false

func _get_topmost_collider(results: Array) -> Node2D:
	var top = results[0].collider
	for r in results:
		var c = r.collider
		if c.z_index > top.z_index or (c.z_index == top.z_index and c.get_index() > top.get_index()):
			top = c
	return top

func set_interaction_paused(value: bool):
	interaction_paused = value
	print("interaction_paused set to ", value)

func _reset():
	set_interaction_paused(false)
