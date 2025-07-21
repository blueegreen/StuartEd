shader_type canvas_item;

uniform vec2 shadow_offset = vec2(4.0, 4.0);
uniform vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.3);
uniform float blur_radius = 2.0;
uniform bool enable_shadow = true;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec4 shadow = vec4(0.0);

	if (enable_shadow) {
		const int samples = 8;
		for (int i = 0; i < samples; i++) {
			float angle = float(i) / float(samples) * 6.28318; // 2π
			vec2 dir = vec2(cos(angle), sin(angle));
			vec2 offset = (shadow_offset + dir * blur_radius) / TEXTURE_PIXEL_SIZE;
			float alpha = texture(TEXTURE, UV - offset).a;
			shadow += shadow_color * alpha;
		}
		shadow /= float(samples);
	}

	// Combine shadow and base color, respecting sprite's modulate (COLOR)
	vec4 final_color = shadow + base * COLOR;
	final_color.a = clamp(final_color.a, 0.0, 1.0); // prevent alpha overflow

	COLOR = final_color;
}
 