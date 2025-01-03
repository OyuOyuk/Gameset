// Shader code for TileMap
shader_type canvas_item;

uniform vec2 mouse_position; // The position of the mouse in the world space
uniform float radius : hint_range(0.0, 500.0) = 100.0; // The radius of visible tiles around the mouse

void fragment() {
    // Get the tile's center position in world space
    vec2 tile_position = FRAGCOORD.xy;
    
    // Calculate the distance between the mouse and the tile
    float dist = length(tile_position - mouse_position);
    
    // Fade out tiles that are farther than the radius
    if (dist > radius) {
        discard; // Makes the tile transparent if it's outside the radius
    } else {
        // Optionally you can apply color effects, here just making it visible
        COLOR = texture(TEXTURE, UV);
    }
}
