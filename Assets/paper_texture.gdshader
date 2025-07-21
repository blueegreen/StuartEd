shader_type canvas_item;

uniform sampler2D paper_tex : hint_default_white;
uniform float paper_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float texture_scale : hint_range(0.1, 10.0) = 1.0;

void fragment() {
    vec4 base_col = texture(TEXTURE, UV);

    // Sample the paper texture in screen space, scaled
    vec2 screen_uv_scaled = SCREEN_UV * texture_scale;
    vec4 paper_col = texture(paper_tex, screen_uv_scaled);

    // Blend base texture with paper texture
    vec3 blended_rgb = mix(base_col.rgb, base_col.rgb * paper_col.rgb, paper_opacity);

    COLOR = vec4(blended_rgb, base_col.a);
}
