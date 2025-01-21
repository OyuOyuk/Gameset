shader_type canvas_item;



uniform sampler2D health_tex;
uniform float scale = 0.01;
varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


void fragment() {
	float mix_amount = floor(COLOR.g);
	vec4 overlay_color_1 = texture(health_tex, world_position*scale);
	COLOR = mix(COLOR, overlay_color_1, mix_amount);
    // If the current fragment's Y position is above the liquid level, make it transparent
	

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
