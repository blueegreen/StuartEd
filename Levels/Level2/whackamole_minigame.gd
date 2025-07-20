extends MinigameScene

@export var drawer : Node2D
@export var keys : Node2D
@export var pop_delay := 1.5
@export var pop_timer : Timer
@export var stuart : Button


var _num_popped := 0

func _ready():
	pop_timer.wait_time = pop_delay
	pop_timer.start()
	await get_tree().process_frame
	for key : RegisterKey in keys.get_children():
		key.stuart_clicked.connect(_on_stuart_key_popped)

func _on_back_button_button_down():
	_end_scene()

func _on_timer_timeout():
	var pop_num = randi_range(1, 2)
	var key_array : Array = []
	for key : RegisterKey in keys.get_children():
		if not key.in_motion:
			key_array.push_back(key)
	
	for i in range(min(key_array.size(), pop_num)):
		var picked_key : RegisterKey = key_array.pick_random()
		picked_key.pop()
		key_array.erase(picked_key)

func _on_stuart_key_popped():
	_num_popped += 1
	if _num_popped == 9:
		pop_timer.stop()
		open_drawer()

func open_drawer():
	var drawer_tween = create_tween()
	var final_pos = drawer.position + Vector2(0, 130)
	var unlock_stuart = func():
		stuart.disabled = false
	drawer_tween.tween_property(drawer, "position", final_pos, 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	drawer_tween.tween_callback(unlock_stuart)

func _on_button_button_down():
	if GameState.level_state:
		GameState.level_state.set_flag("stuart found", true)
		_end_scene()
	
