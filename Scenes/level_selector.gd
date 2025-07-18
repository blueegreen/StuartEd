extends Control

@export var level_images: Array[Texture2D] = []
@onready var frame_box: Control = $FrameBox
@onready var slide_area: Control = $FrameBox/SlideArea
@export var left_button: TextureButton
@export var right_button: TextureButton
@export var select_button: TextureButton

var current_index := 0
var is_animating := false

@export var level_scenes: Array[String]

func _ready() -> void:
	if level_images.is_empty():
		return

	_show_level(current_index)

	left_button.pressed.connect(_on_left_button)
	right_button.pressed.connect(_on_right_button)
	select_button.pressed.connect(_on_select_button_pressed)


func _show_level(index: int) -> void:
	slide_area.get_children().map(func(c): c.queue_free())

	var tex := TextureRect.new()
	var texture := level_images[index]
	tex.texture = texture
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tex.anchor_left = 0
	tex.anchor_top = 0
	tex.anchor_right = 1
	tex.anchor_bottom = 1
	tex.offset_left = 0
	tex.offset_top = 0
	tex.offset_right = 0
	tex.offset_bottom = 0

	# Resize frame_box to match texture size
	if texture:
		var tex_size := texture.get_size()
		frame_box.custom_minimum_size = tex_size
		frame_box.size = tex_size

	slide_area.add_child(tex)

func _on_left_button() -> void:
	if is_animating or level_images.size() <= 1:
		return

	var next_index = (current_index - 1 + level_images.size()) % level_images.size()
	_animate_switch(next_index, false)

func _on_right_button() -> void:
	if is_animating or level_images.size() <= 1:
		return

	var next_index = (current_index + 1) % level_images.size()
	_animate_switch(next_index, true)

func _on_select_button_pressed() -> void:
	var selected_level_path = level_scenes[current_index]

	if ResourceLoader.exists(selected_level_path):
		get_tree().change_scene_to_file(selected_level_path)
	else:
		print("Level not found:", selected_level_path)


func _animate_switch(next_index: int, to_left: bool) -> void:
	is_animating = true

	var old_tex = slide_area.get_child(0)
	var new_tex := TextureRect.new()
	var texture := level_images[next_index]
	new_tex.texture = texture
	new_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_tex.anchor_left = 0
	new_tex.anchor_top = 0
	new_tex.anchor_right = 1
	new_tex.anchor_bottom = 1
	new_tex.offset_left = 0
	new_tex.offset_top = 0
	new_tex.offset_right = 0
	new_tex.offset_bottom = 0

	var tex_size := texture.get_size()
	frame_box.custom_minimum_size = tex_size
	frame_box.size = tex_size

	var offset = tex_size.x
	new_tex.position = Vector2(-offset if to_left else offset, 0)
	slide_area.add_child(new_tex)

	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(old_tex, "position", Vector2(offset if to_left else -offset, 0), 0.3)
	tween.tween_property(new_tex, "position", Vector2(0, 0), 0.3)

	await tween.finished
	old_tex.queue_free()
	current_index = next_index
	is_animating = false
