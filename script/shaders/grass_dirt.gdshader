shader_type canvas_item;
uniform sampler2D grass_tex : repeat_enable, filter_nearest;
uniform sampler2D dirt_tex : repeat_enable, filter_nearest;
uniform float scale_1 = 0.006944444;
uniform float scale_2 = 0.006944444;
varying vec2 world_position;
void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	float mix_amount = floor(COLOR.r);
	vec4 overlay_color_1 = texture(grass_tex, world_position*scale_1);
	COLOR = mix(COLOR, overlay_color_1, mix_amount);
	mix_amount = floor(COLOR.b);
	vec4 overlay_color_2 = texture(dirt_tex, world_position * scale_2);
	COLOR = mix(COLOR, overlay_color_2, mix_amount);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
