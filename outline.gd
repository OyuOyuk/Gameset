extends Node2D  # or the parent node of your TileMap

@export var radius: float = 100.0  # Radius for tile visibility
var shader_material : ShaderMaterial
var size = Vector2i(100,100)

func _ready() -> void:
	var tilemap = $outline  # Get the TileMap node (adjust if it's nested)
	for x in range(-size.x / 2, size.x / 2):
		for y in range(-size.y / 2, size.y / 2):
			tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0))
	
	if tilemap != null and tilemap.material is ShaderMaterial:
		shader_material = tilemap.material as ShaderMaterial
		# Set the initial shader parameter for radius
		shader_material.set_shader_parameter("radius", radius)
	else:
		print("TileMap or ShaderMaterial not found!")

func _process(delta: float) -> void:
	if shader_material:
		# Get the mouse position in global coordinates
		var global_mouse_pos = get_viewport().get_mouse_position()
		
		# Convert to TileMap local coordinates
		var local_mouse_pos = $outline.to_local(global_mouse_pos)
		
		# Pass the mouse position to the shader for fade effect
		shader_material.set_shader_parameter("mouse_position", local_mouse_pos)
