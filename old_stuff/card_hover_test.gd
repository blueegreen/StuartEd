extends Button

@export var normal: Marker2D
@export var enabled: bool = true
@export var hover_position_clamp: float = 2000

var is_being_held := false
var mouse_target := Vector2.ZERO
var hover_velocity := Vector2.ZERO
var idle_velocity := Vector2.ZERO
var previous_idle_pos := Vector2.ZERO
var time_accumulator := 0.0

func _input(event: InputEvent) -> void:
	if not enabled:
		return

	if event is InputEventMouseMotion:
		mouse_target = event.position - (Vector2(140, 186) / 2)
		hover_velocity = clamp(event.velocity / 4000.0, Vector2(-0.3, -0.3), Vector2(0.3, 0.3))

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		is_being_held = false

func _on_button_down() -> void:
	is_being_held = true

func _process(delta: float) -> void:
	if not enabled:
		self.visible = false
		self.position = normal.position
		self.rotation = 0
		return

	self.visible = true
	time_accumulator += delta

	var local_center := self.position + self.size / 2
	var shader_material := material as ShaderMaterial

	if is_being_held:
		self.position = lerp(self.position, mouse_target, 0.25)
		self.rotation += clamp(hover_velocity.x, -0.3, 0.3)
		self.rotation *= 0.8
		self.scale = self.scale.lerp(Vector2(1.05, 1.05), 0.25)
		hover_velocity = Vector2.ZERO
	else:
		self.position = lerp(self.position, normal.position, 0.25)

		idle_velocity = (self.position - previous_idle_pos) * 0.01532
		previous_idle_pos = self.position

		self.rotation += clamp(idle_velocity.x, -0.3, 0.25)
		self.rotation *= 0.8

		self.rotation += sin(time_accumulator + 1321) * (0.003625 / 2)
		self.position.x += cos(time_accumulator + 180 + 1321) * (0.875 / 2)
		self.position.y += sin(time_accumulator + 360 + 1231) * (0.875 / 2)

		if shader_material and is_cursor_touching():
			self.scale = self.scale.lerp(Vector2(1.05, 1.05), 0.25)
			shader_material.set_shader_parameter("hovering", 1)
			var offset = (get_global_mouse_position() - local_center) * 2.0
			offset.x = clampf(offset.x, -hover_position_clamp, hover_position_clamp)
			offset.y = clampf(offset.y, -hover_position_clamp, hover_position_clamp)
			shader_material.set_shader_parameter("mouse_screen_pos", offset)
		elif shader_material:
			self.scale = self.scale.lerp(Vector2(1, 1), 0.25)
			shader_material.set_shader_parameter("hovering", 0)

func is_cursor_touching() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())
