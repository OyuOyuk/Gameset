shader_type canvas_item;

uniform sampler2D alpha_texture;
uniform vec2 alpha_offset = vec2(0.0, 0.0); // Offset for alpha texture
uniform vec2 alpha_scale = vec2(1.0, 1.0);  // Scale of the alpha texture
uniform vec2 pixel_size = vec2(1.0, 1.0);   // Size of a single pixel (e.g., 1 / texture width, 1 / texture height)

void fragment() {
    // Snap UVs to pixel grid for sharp edges
    vec2 pixel_uv = floor(UV / pixel_size) * pixel_size;

    // Sample the base texture (sprite's default texture)
    vec4 base_color = texture(TEXTURE, pixel_uv);

    // Transform UV for alpha texture
    vec2 alpha_uv = floor((UV + alpha_offset) / alpha_scale / pixel_size) * pixel_size;

    // Sample the alpha texture
    vec4 alpha_color = texture(alpha_texture, alpha_uv);

    // Combine the alpha channel of the alpha texture with the base texture
    float combined_alpha = base_color.a * alpha_color.a;

    // Output the result
    COLOR = vec4(base_color.rgb, combined_alpha);
}

