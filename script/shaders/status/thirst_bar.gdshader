shader_type canvas_item;



uniform sampler2D thirst_tex;
uniform float scale = 0.01;
varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


void fragment() {
	float mix_amount = floor(COLOR.g);
	vec4 overlay_color_1 = texture(thirst_tex, world_position*scale);
	COLOR = mix(COLOR, overlay_color_1, mix_amount);
    // If the current fragment's Y position is above the liquid level, make it transparent
	

}