extends MinigameScene

enum state {FREE, LOCKED}
var _current_state : state = state.FREE

@export var animation_player : AnimationPlayer
@export var gacha_ball_scene : PackedScene
@export var path_follow : PathFollow2D
@export var claw : Node2D
@export var claw_attacher : Area2D
@export var speed : float = 0.3
@export var down_speed : float = 80.
@export var max_distance_lowered : float = 172.

var _left_down := false
var _right_down := false
var _down_down := false

var _claw_start_pos : Vector2
var _grabbed_ball : GachaBall = null

signal stuart_found

func _ready():
	_claw_start_pos = claw.position
	await get_tree().create_timer(.1).timeout
	var dialogue_script : Array[String] = [\
	"left: stuart should be in one of these...",\
	"left: do I have enough information to figure it out?"\
	]
	GameState.dialogue_manager.start_dialogue(dialogue_script)

func _process(delta):
	match _current_state:
		state.FREE:
			if _left_down:
				path_follow.progress_ratio = clamp(path_follow.progress_ratio - speed * delta, 0, 1)
			elif _right_down:
				path_follow.progress_ratio = clamp(path_follow.progress_ratio + speed * delta, 0, 1)
			elif _down_down:
				claw.position.y = clamp(claw.position.y + down_speed * delta, _claw_start_pos.y, _claw_start_pos.y + max_distance_lowered)

func _on_left_button_down():
	_left_down = true
	SfxManager.play_sfx("robot_arm")


func _on_down_button_down():
	_down_down = true
	SfxManager.play_sfx("robot_arm")


func _on_right_button_down():
	_right_down = true
	SfxManager.play_sfx("robot_arm")


func _on_left_button_up():
	_left_down = false


func _on_down_button_up():
	_down_down = false
	_current_state = state.LOCKED

	for body in claw_attacher.get_overlapping_bodies():
		if body is GachaBall and body.get_parent() == self:
			_grabbed_ball = body
			
			_grabbed_ball.set_freeze_enabled(true)
			var trans = _grabbed_ball.global_transform
			remove_child(_grabbed_ball)
			claw.add_child(_grabbed_ball)
			_grabbed_ball.global_transform = trans
			break
	
	SfxManager.play_sfx("cashregisterclick", -15)
	var claw_final_pos = Vector2(claw.position.x, _claw_start_pos.y)
	var tween = create_tween()
	tween.tween_property(claw, "position", claw_final_pos, 0.8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(check_and_shuffle)


func _on_right_button_up():
	_right_down = false


func check_and_shuffle():
	if _grabbed_ball:
		if _grabbed_ball.is_stuart:
			print("stuart_found")
			stuart_found.emit()
			if GameState.level_state:
				GameState.level_state.set_flag("stuart found", true)
				_end_scene()
				return
			#end_scene()
		var trans = _grabbed_ball.global_transform
		claw.remove_child(_grabbed_ball)
		add_child(_grabbed_ball)
		_grabbed_ball.global_transform = trans
		_grabbed_ball.set_freeze_enabled(false)
		
		_grabbed_ball = null
	
	animation_player.play("shuffle")
	SfxManager.play_sfx("slot_machine", -15)
	_current_state = state.FREE


func _on_back_button_toggled(_toggled_on):
	_end_scene()
