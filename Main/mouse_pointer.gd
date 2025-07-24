extends Node2D

@export var mouse_sprite : Sprite2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	global_position = get_global_mouse_position()
	if not InputManager.interaction_paused:
		var space_state = get_world_2d().direct_space_state
		var point_query = PhysicsPointQueryParameters2D.new()
		point_query.position = get_global_mouse_position()
		point_query.collide_with_areas = true
		point_query.collide_with_bodies = false
		point_query.collision_mask = 2**0
		var result = space_state.intersect_point(point_query)
		if result.size() > 0:
			var top = _get_topmost_collider(result)
			if top is Player:
				pass
			elif top is CharacterActor:
				mouse_sprite.frame = 1
				return
			elif top is Actor:
				mouse_sprite.frame = 2
				return
	mouse_sprite.frame = 0

func _get_topmost_collider(results: Array) -> Node2D:
	var top = results[0].collider
	for r in results:
		var c = r.collider
		if c.z_index > top.z_index or (c.z_index == top.z_index and c.get_index() > top.get_index()):
			top = c
	return top
