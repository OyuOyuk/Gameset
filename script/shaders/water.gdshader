shader_type canvas_item;
uniform sampler2D overlay_tex :repeat_enable, filter_nearest;
uniform sampler2D noise_tex : repeat_enable;
uniform float scale = 0.01;
varying vec2 world_position;
void vertex(){
	world_position = (MODEL_MATRIX *vec4(VERTEX, 0.0, 1.0)).xy;
}
void fragment(){
	float mix_amount = floor(COLOR.r);
	
	vec4 overlay_color = texture(noise_tex, world_position*scale);
	overlay_color.r = 0.1;
	overlay_color.g = 0.1;
	COLOR = mix(COLOR, overlay_color, mix_amount);

}