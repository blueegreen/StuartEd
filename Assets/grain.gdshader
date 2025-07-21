shader_type canvas_item;

uniform float grain_strength = 0.05; // adjust intensity
uniform float speed = 1.0;

void fragment() {
    // Simple hash noise based on screen UV and time
    vec2 uv = FRAGCOORD.xy;
    float noise = fract(sin(dot(uv ,vec2(12.9898,78.233))) * 43758.5453 + TIME * speed);

    // Create monochrome grain effect
    float grain = (noise - 0.5) * 2.0 * grain_strength;

    // Combine with base color (from modulate or material_color)
    COLOR = vec4(COLOR.rgb + grain, COLOR.a);
}
