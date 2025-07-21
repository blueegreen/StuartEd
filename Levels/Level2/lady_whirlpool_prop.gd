extends Node2D
class_name WhirlpoolProp

@export var orbit_centre := Vector2.ZERO
@export var container_radius := 230.0

var _velocity: Vector2 = Vector2.ZERO
var _acceleration: float = 0.0
var _angular_perturbation := 0.0
var _rotation_speed := 0.
var _is_ed := false
var _paused := false
var _active_area : Area2D

signal ed_clicked
signal click_again

func set_id(is_ed := false):
	_is_ed = is_ed
	var id : int = 4 if is_ed else randi_range(0, 3)
	if get_child(id) is Area2D:
		_active_area = get_child(id)
		_active_area.collision_layer = 5
		_active_area.visible = true

func _ready():
	scale *= randf_range(0.8, 1)
	
	# Random starting position inside the circle
	var angle = randf_range(0, TAU)
	var dist = randf_range(container_radius * 0.5, container_radius * 1.2)
	global_position = orbit_centre + Vector2.RIGHT.rotated(angle) * dist

	# Orbital parameters
	var vector_to_centre = orbit_centre - global_position
	var orbit_radius = vector_to_centre.length()
	var orbital_time = randf_range(4.5, 6.0)
	var speed = (2.0 * PI * orbit_radius) / orbital_time
	_rotation_speed = .003 * speed
	_rotation_speed *= -1 if randi() % 2 == 0 else 1

	# Tangential velocity
	_velocity = vector_to_centre.normalized().rotated(PI / 2.0) * speed
	if randi() % 2 == 0:
		_velocity = -_velocity

	# Central acceleration (simplified gravity-style orbit)
	_acceleration = speed * speed / orbit_radius
	_angular_perturbation = randf_range(-0.5, 0.5)

func _process(delta):
	if _paused:
		return
	var to_centre = orbit_centre - global_position
	var distance = to_centre.length()

	# Update velocity with central acceleration
	var acceleration_vec = to_centre.normalized() * _acceleration
	_velocity += acceleration_vec * delta

	# Slight dynamic orbiting variation
	_velocity = _velocity.rotated(_angular_perturbation * delta)

	global_position += _velocity * delta

	# Bounce if outside bounds
	if distance > container_radius:
		var normal = (global_position - orbit_centre).normalized()
		_velocity = _velocity.bounce(normal)
		_velocity = _velocity.rotated(randf_range(-0.15, 0.15))  # Adds chaos
		global_position = orbit_centre + normal * container_radius
		_rotation_speed *= -1
	
	rotation += _rotation_speed * delta

func on_click():
	await get_tree().process_frame
	_paused = true
	_active_area.collision_layer = 0
	z_index = 1
	
	var current_transform := global_transform
	
	var check = func():
		if _is_ed:
			SfxManager.play_sfx("ed_caught")
			ed_clicked.emit()
			var fade_tween = create_tween()
			fade_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			fade_tween.tween_callback(end_check)
		else:
			SfxManager.play_sfx("ed_not_caught")
			_paused = false
			_active_area.collision_layer = 5
			var revert_tween = create_tween()
			revert_tween.tween_property(self, "global_transform", current_transform, 0.75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			revert_tween.tween_callback(end_check)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", orbit_centre, .75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel().tween_property(self, "global_rotation", 2 * PI, .75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel().tween_property(self, "global_scale", Vector2(2.5, 2.5), .75).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false).tween_callback(check)

func end_check():
	click_again.emit()
	z_index = 0
