extends Sprite2D

# Base texture
var base_texture: Texture
# Alpha texture
var alpha_texture: Texture

# A shader material for combining the textures
var shader_material: ShaderMaterial

func _ready():
	# Load the textures (set paths to your textures)
	base_texture = preload("res://assets/ui/liquid.png")
	alpha_texture = preload("res://assets/ui/water.png")

	# Create the shader material
	shader_material = ShaderMaterial.new()
	shader_material.shader = Shader.new()
	shader_material.shader.code = """
		shader_type canvas_item;

		uniform sampler2D base_texture;
		uniform sampler2D alpha_texture;
		uniform vec2 alpha_position;
		uniform vec2 alpha_scale;

		void fragment() {
			// Get UV coordinates for the base texture
			vec4 base_color = texture(base_texture, UV);

			// Transform UVs to maintain alpha texture position
			vec2 alpha_uv = (UV - alpha_position) / alpha_scale;

			// Get the alpha texture color
			vec4 alpha_color = texture(alpha_texture, alpha_uv);

			// Apply alpha channel of the alpha texture to the base texture
			float alpha = alpha_color.a;
			COLOR = vec4(base_color.rgb, base_color.a * alpha);
		}
	"""

	# Set shader uniforms
	shader_material.set_shader_param("base_texture", base_texture)
	shader_material.set_shader_param("alpha_texture", alpha_texture)
	shader_material.set_shader_param("alpha_position", Vector2(0.0, 0.0)) # Starting position of the alpha texture
	shader_material.set_shader_param("alpha_scale", Vector2(1.0, 1.0))    # Scale of the alpha texture

	# Apply the material to this sprite
	self.material = shader_material

func _process(delta):
	# Update alpha position to match some movement logic
	# Example: Make alpha position follow this node's position
	shader_material.set_shader_param("alpha_position", self.global_position / self.texture.get_size())
