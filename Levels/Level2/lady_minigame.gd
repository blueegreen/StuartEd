extends MinigameScene

@export var num_of_objects := 8
@export var num_of_ed := 3
@export var centre_marker : Marker2D
@export var prop_scene : PackedScene

var _ed_props_clicked := 0
var _input_paused := false

func _ready():
	var add_prop = func(is_ed: bool):
		var new_prop : WhirlpoolProp = prop_scene.instantiate()
		new_prop.orbit_centre = centre_marker.global_position
		#new_prop.global_position = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(150, 250) + centre_marker.global_position
		new_prop.ed_clicked.connect(ed_prop_clicked)
		add_child(new_prop)
		new_prop.set_id(is_ed)

	for i in range(num_of_ed):
			add_prop.call(true)
	for i in range(num_of_objects):
		add_prop.call(false)
	

func _unhandled_input(event):
	if event.is_action_pressed("click") and not event.is_echo() and not _input_paused:
		var space_state = get_viewport().get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = 4
		var result = space_state.intersect_point(query)
		var top_result : Dictionary
		if result.size() > 0:
			top_result = result[0]
			for r in result:
				if r.collider.get_parent().get_index() > top_result.collider.get_parent().get_index():
					top_result = r
			var top_prop = top_result.collider.get_parent()
			if top_prop is WhirlpoolProp:
				top_prop.on_click()
				_input_paused = true
				await top_prop.click_again
				_input_paused = false

func ed_prop_clicked():
	_ed_props_clicked += 1
	if _ed_props_clicked >= num_of_ed:
		if GameState.level_state:
			GameState.level_state.set_flag("ed found", true)
			_end_scene()

func _on_back_button_button_down():
	_end_scene()
