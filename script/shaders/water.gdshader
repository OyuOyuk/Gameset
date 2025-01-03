shader_type canvas_item;

void fragment() {
	
	if (COLOR == vec4(0.0, 0.0, 0.0, 1.0)){
		COLOR.rgb = vec3(0.493, 0.758, 0.9160);
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
