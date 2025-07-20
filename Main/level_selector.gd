extends Control

@export var level_images: Array[Texture2D] = []
@export var frame_box: Panel
@export var slide_area: Container
@export var right_button: TextureButton
@export var left_button: TextureButton
@export var select_button: TextureButton
@export var level_scenes: Array[PackedScene]
@export var area: Area2D
@export var blur: ColorRect
@export var label: Label

var current_index := 0
var is_animating := false

func _ready() -> void:
	if level_images.is_empty():
		return
	_show_level(current_index)

	right_button.pressed.connect(_on_right_button)
	left_button.pressed.connect(_on_left_button)
	select_button.pressed.connect(_on_select_button_pressed)
	
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)

	blur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	area.z_index = 1
	blur.hide()
	label.hide()

func _on_mouse_entered():
	blur.show()
	label.show()

func _on_mouse_exited():
	blur.hide()
	label.hide()

func _show_level(index: int) -> void:
	slide_area.get_children().map(func(c): c.queue_free())

	var texture := level_images[index]
	var tex := TextureRect.new()
	tex.texture = texture
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	if texture:
		var tex_size := texture.get_size()
		frame_box.custom_minimum_size = tex_size
		frame_box.size = tex_size

		# Center anchors
		tex.anchor_left = 0.5
		tex.anchor_top = 0.5
		tex.anchor_right = 0.5
		tex.anchor_bottom = 0.5
		tex.offset_left = -tex_size.x / 2
		tex.offset_top = -tex_size.y / 2
		tex.offset_right = tex_size.x / 2
		tex.offset_bottom = tex_size.y / 2
		tex.position = Vector2(0, 0)

	slide_area.add_child(tex)


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
	var selected_level = level_scenes[current_index]

	if ResourceLoader.exists(selected_level.resource_path):
		get_tree().change_scene_to_packed(selected_level)
	else:
		print("Level not found:", selected_level)

func _animate_switch(next_index: int, to_left: bool) -> void:
	is_animating = true

	var old_tex = slide_area.get_child(0)
	var texture := level_images[next_index]
	var new_tex := TextureRect.new()
	new_tex.texture = texture
	new_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	if texture:
		var tex_size := texture.get_size()
		frame_box.custom_minimum_size = tex_size
		frame_box.size = tex_size

		new_tex.anchor_left = 0.5
		new_tex.anchor_top = 0.5
		new_tex.anchor_right = 0.5
		new_tex.anchor_bottom = 0.5
		new_tex.offset_left = -tex_size.x / 2
		new_tex.offset_top = -tex_size.y / 2
		new_tex.offset_right = tex_size.x / 2
		new_tex.offset_bottom = tex_size.y / 2

		var offset = tex_size.x
		new_tex.position = Vector2(-offset if to_left else offset, 0)

	slide_area.add_child(new_tex)

	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(old_tex, "position", Vector2(texture.get_size().x if to_left else -texture.get_size().x, 0), 0.3)
	tween.tween_property(new_tex, "position", Vector2(0, 0), 0.3)

	await tween.finished
	old_tex.queue_free()
	current_index = next_index
	is_animating = false
