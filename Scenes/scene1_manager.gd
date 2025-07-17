extends Control
#var hats := ["red","blue","yellow"]
#var clothes := ["red","blue","yellow"]
#var shoes := ["red","blue","yellow"]
var stuart_pointer :int = 0
var tween: Tween

@export var gallery : HBoxContainer
@export var selector_box : ColorRect
@onready var line_edit: LineEdit = $LineEdit


@export var sprite_textures :Array[Texture2D] = []
var current_index : int = 0

var appearal : Dictionary

func _ready() -> void:
	shuffle_gallery()
	
#func appearal_set(): 
	#appearal[1] = ["red", "blue", "red"] #this is mr. stuart
	#appearal[2] = ["blue", "red", "yellow"]
	#appearal[3] = ["red", "blue", "red"]
	#appearal[4] = ["yellow", "blue", "blue"]
	#appearal[5] = ["red", "blue", "blue"]
	#appearal[6] = ["blue", "blue", "yellow"]
	#appearal[7] = ["blue", "yellow", "red"]

func shuffle_gallery():
	var n = sprite_textures.size()
	var forward_by:int = randi_range(2,n)
	stuart_pointer = forward_by % n
	var last: Texture2D
	for i in range(0, forward_by):
		last = sprite_textures[n - 1]
		for j in range(n - 1, 0, -1):
			sprite_textures[j] = sprite_textures[j - 1]
		sprite_textures[0] = last
	for child in gallery.get_children():
		gallery.remove_child(child)
		child.queue_free()
	populate_gallery()

func populate_gallery():
	for tex in sprite_textures:
		var tex_rect := TextureRect.new()
		tex_rect.texture = tex
		tex_rect.expand_mode = TextureRect.ExpandMode.EXPAND_KEEP_SIZE
		tex_rect.stretch_mode = TextureRect.StretchMode.STRETCH_KEEP
		tex_rect.custom_minimum_size = Vector2(128, 128)
		tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		gallery.add_child(tex_rect)

func update_selector_position(animated := true):
	var selected := gallery.get_child(current_index)

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	if animated:
		tween.tween_property(selector_box, "global_position", selected.global_position, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(selector_box, "size", selected.size, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	else:
		selector_box.global_position = selected.global_position
		selector_box.size = selected.size

func _on_r_button_button_down() -> void:
	current_index = (current_index + 1) % gallery.get_child_count()
	update_selector_position()


func _on_l_button_button_down() -> void:
	current_index = (current_index - 1 + gallery.get_child_count()) % gallery.get_child_count()
	update_selector_position()


func _on_confirm_button_button_down() -> void:
	if current_index == stuart_pointer:
		line_edit.text = "Social credit +100"
	else:
		line_edit.text = "Social credit -10000"
