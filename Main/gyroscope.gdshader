shader_type canvas_item;

uniform float bend_strength = 0.05;
uniform vec2 mouse_offset = vec2(0.0, 0.0);

void fragment() {
	vec2 uv = UV;

	// Fake 3D bend effect (based on mouse offset)
	uv.x += (0.5 - UV.y) * mouse_offset.x * bend_strength;
	uv.y += (0.5 - UV.x) * mouse_offset.y * bend_strength;

	COLOR = texture(TEXTURE, uv) * COLOR;
}
