extends Node2D

@export var level_images: Array[Texture2D] = []
@export var level_scenes: Array[PackedScene] = []
@export var stage_names: Array[String] = []

@export var stage_name : Label

@export var level_texture: TextureRect
@export var blur_overlay: TextureRect
@export var left_button: TextureButton
@export var right_button: TextureButton
@export var hover_detector: Area2D
@export var hover_shape: CollisionShape2D

var current_index: int = 0
var transition_tween: Tween = null

var max_rotation_deg: float = 5.0
var max_scale_offset: float = 0.02
var current_angle: float = 0.0
var current_scale: Vector2 = Vector2.ONE

func _ready():
	if level_images.is_empty(): return
	
	current_index = GameState.current_level_id
	level_texture.texture = level_images[current_index]
	stage_name.text = stage_names[current_index]
	level_texture.modulate = Color(1, 1, 1, 1)
	level_texture.mouse_filter = Control.MOUSE_FILTER_STOP

	level_texture.gui_input.connect(_on_texture_gui_input)
	level_texture.mouse_entered.connect(_on_mouse_enter)
	level_texture.mouse_exited.connect(_on_mouse_exit)
	left_button.pressed.connect(_on_LeftButton_pressed)
	right_button.pressed.connect(_on_RightButton_pressed)

	blur_overlay.visible = false
	blur_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	blur_overlay.material = preload("res://Main/blur_material.tres")
	blur_overlay.modulate.a = 0.6 

	hover_detector.mouse_entered.connect(_on_mouse_enter)
	hover_detector.mouse_exited.connect(_on_mouse_exit)

	await get_tree().process_frame
	level_texture.set_pivot_offset(level_texture.size / 2)
	level_texture.scale = Vector2.ONE * .75

	blur_overlay.set_pivot_offset(level_texture.size / 2)

	_update_hover_detector()

func _update_hover_detector():
	var full_size = level_texture.size * level_texture.scale
	var hover_size = full_size * 0.9

	var shape := RectangleShape2D.new()
	shape.extents = hover_size / 2
	hover_shape.shape = shape

	hover_detector.position = level_texture.position + (full_size - hover_size) / 2

func show_level(index: int):
	if index < 0 or index >= level_images.size():
		return

	if transition_tween:
		transition_tween.kill()

	transition_tween = create_tween()
	transition_tween.set_parallel(false)
	transition_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	transition_tween.tween_property(level_texture, "modulate", Color.TRANSPARENT, 0.25)
	transition_tween.set_parallel().tween_property(stage_name, "modulate", Color.TRANSPARENT, 0.25)
	
	transition_tween.set_parallel(false).tween_callback(func():
		current_index = index
		level_texture.texture = level_images[current_index]
		stage_name.text = stage_names[current_index]

		level_texture.set_pivot_offset(level_texture.size / 2)
		blur_overlay.set_pivot_offset(level_texture.size / 2)
		_update_hover_detector()

		level_texture.modulate.a = 0.0
	)

	transition_tween.tween_property(level_texture, "modulate", Color.WHITE, 0.25).set_delay(0.01)
	transition_tween.set_parallel().tween_property(stage_name, "modulate", Color.WHITE, 0.25).set_delay(0.01)

func _on_texture_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_index < level_scenes.size():
			MusicManager.play_song(current_index + 1)
			get_tree().change_scene_to_packed(level_scenes[current_index])

func _on_mouse_enter():
	blur_overlay.visible = true

func _on_mouse_exit():
	blur_overlay.visible = false

func _on_LeftButton_pressed():
	show_level((current_index - 1 + level_images.size()) % level_images.size())

func _on_RightButton_pressed():
	show_level((current_index + 1) % level_images.size())

func _process(delta):
	var offset = Vector2.ZERO
	if blur_overlay.visible:
		var local_mouse = level_texture.get_local_mouse_position()
		var center = level_texture.size / 2.0
		offset = (local_mouse - center) / center

		var target_angle = offset.x * -max_rotation_deg
		var target_scale = Vector2.ONE * .75 + Vector2(offset.x, -offset.y) * max_scale_offset

		current_angle = lerp(current_angle, target_angle, delta * 6.0)
		current_scale = current_scale.lerp(target_scale, delta * 6.0)
	else:
		current_angle = lerp(current_angle, 0.0, delta * 6.0)
		current_scale = current_scale.lerp(Vector2.ONE * .75, delta * 6.0)

	level_texture.rotation_degrees = current_angle
	level_texture.scale = current_scale
	level_texture.set_pivot_offset(level_texture.size / 2)

	blur_overlay.rotation_degrees = current_angle
	blur_overlay.scale = current_scale
	blur_overlay.set_pivot_offset(level_texture.size / 2)

	_update_hover_detector()


func _on_button_button_down():
	MusicManager.play_song(0)
	get_tree().change_scene_to_file("res://Main/start_scene.tscn")
