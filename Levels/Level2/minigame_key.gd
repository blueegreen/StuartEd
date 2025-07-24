extends Button
class_name RegisterKey

@export var number := 1
@export var label : Label
@export var particles : CPUParticles2D

@export var key : Node2D
@export var key_stuart : Node2D
@export var max_height := 40
@export var pop_time := 1.

enum state {STUART, BLANK, POPPED}
var _current_state := state.BLANK
var _init_pos : Vector2
var in_motion := false

var vel := Vector2(0, 0)
var grav := 600.
var rot_dir := 1
var pop_tween : Tween

signal stuart_clicked

func _ready():
	label.text = str(number)
	_init_pos = position
	disabled = true
	key_stuart.modulate = Color(1, 1, 1, 0)

func _process(delta):
	if _current_state == state.POPPED:
		vel.y += grav * delta
		key.position += vel * delta
		key.rotation += rot_dir * 0.8 * delta

func pop():
	if randf_range(0, 10) < 4.:
		_current_state = state.STUART
		key_stuart.modulate = Color(1, 1, 1, 1)
	else:
		_current_state = state.BLANK
		key_stuart.modulate = Color(1, 1, 1, 0)
	disabled = false
	
	in_motion = true
	var end_motion = func():
		in_motion = false
		disabled = true

	if pop_tween:
		pop_tween.kill()
	pop_tween = create_tween()
	pop_tween.tween_property(self, "position", Vector2(0, -40) + _init_pos, pop_time/2.).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(self, "position", Vector2(0, 0) + _init_pos, pop_time/4.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	pop_tween.set_parallel().tween_property(key_stuart, "modulate", Color(1, 1, 1, 0), pop_time/4.).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(self, "_current_state", state.BLANK, pop_time/8.)
	pop_tween.set_parallel(false).tween_callback(end_motion)
	
func _on_button_down():
	if _current_state == state.STUART:
		SfxManager.play_sfx("mole_caught",-15)
		stuart_clicked.emit()
		_pop_off()
	else:
		SfxManager.play_sfx("cashregisterclick", -15)

func _pop_off():
	if pop_tween:
		pop_tween.kill()
	_current_state = state.POPPED
	in_motion = true
	disabled = true
	
	particles.emitting = true
	vel = Vector2(randf_range(-60, 60), randf_range(-500, -600))
	rot_dir = 1 if vel.x > 0 else -1
	var fade_tween = create_tween()
	fade_tween.tween_property(key_stuart, "modulate", Color(1, 1, 1, 0), .5).set_ease(Tween.EASE_IN)
	fade_tween.set_parallel().tween_property(key_stuart, "position", Vector2(53, 130), .5).set_ease(Tween.EASE_IN)
	fade_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 3).set_ease(Tween.EASE_OUT)
