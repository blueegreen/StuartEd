shader_type canvas_item;

uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 dark_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float square_size = 32.0;
uniform float scroll_speed = 50.0;
uniform float angle = 0.0; // In degrees
uniform vec2 canvas_size = vec2(512.0, 512.0); // Set from script or inspector

void fragment() {
    float rad = radians(angle);
    vec2 scroll_dir = vec2(cos(rad), sin(rad));
    vec2 scroll = TIME * scroll_speed * scroll_dir;

    // Convert UV (0-1) to pixel space
    vec2 pos = UV * canvas_size - scroll;

    // Rotate coordinates
   mat2 rot = mat2(
    vec2(cos(rad), sin(rad)),
    vec2(-sin(rad), cos(rad))
   );

    pos = rot * pos;

    // Create checker pattern
    vec2 cell = floor(pos / square_size);
    float check = mod(cell.x + cell.y, 2.0);
    COLOR = mix(light_color, dark_color, check);
}
