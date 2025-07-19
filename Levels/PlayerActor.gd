extends CharacterActor
class_name Player

signal finished_walk

@export var speed := 200.0
@export var minimum_walk_distance := 10.0

var _walk_tween : Tween
var _walking = false

func _ready():
	super()
	GameState.player = self
	z_index = 2

func walk_to_point(pos: Vector2):
	if _walking:
		push_warning("walk called again during walk")
		return
	
	if not (get_parent() is PathFollow2D and get_parent().get_parent() is Path2D):
		end_walk()
		push_warning("Player path_follow not setup properly")
		return
	
	var path_follow : PathFollow2D = get_parent()
	var path : Path2D = path_follow.get_parent()
	var curve := path.curve

	var local_pos = path.to_local(pos)

	var closest_offset := curve.get_closest_offset(local_pos)
	var curve_length := curve.get_baked_length()

	var current_distance := path_follow.progress_ratio * curve_length
	var distance : float = abs(closest_offset - current_distance)

	if distance < minimum_walk_distance:
		end_walk()
		return

	#start_walk
	
	try_animation("walk")
	var direction = sign(closest_offset - current_distance)
	scale.x = direction

	var walk_time = distance / speed
	var target_ratio := closest_offset / curve_length
	if _walk_tween:
		_walk_tween.kill()

	_walk_tween = create_tween()
	_walk_tween.tween_property(path_follow, "progress_ratio", target_ratio, walk_time)
	_walk_tween.tween_callback(end_walk)

func walk_to_actor(actor: Actor):
	walk_to_point(actor.global_position)

func end_walk():
	try_animation("idle")
	await get_tree().process_frame
	finished_walk.emit()
