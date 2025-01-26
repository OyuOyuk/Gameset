extends Node2D
var sprite_regions = [
	Rect2(0, 0, 160, 128),   # First sprite
	Rect2(160, 0, 160, 128), # Second sprite (different height)
	Rect2(320, 0, 160, 128), # Third sprite
	Rect2(480, 0, 160, 128),
	Rect2(0, 128, 160, 192),   # First sprite
	Rect2(160, 128, 160, 192), # Second sprite (different height)
	Rect2(320, 128, 160, 192),
	Rect2(480, 128, 160, 192),
	Rect2(0, 320, 160, 224),   # First sprite
	Rect2(160, 320, 160, 224), # Second sprite (different height)
	Rect2(320, 320, 160, 224),
	Rect2(480, 320, 160, 224),
	# Add more as needed
]

var dict = {
	Vector2i(0, 0) : 0,
	Vector2i(5, 0) : 1,
	Vector2i(10, 0) : 2,
	Vector2i(15, 0) : 3,
	Vector2i(0, 4) : 4,
	Vector2i(5, 4) : 5,
	Vector2i(10, 4) : 6,
	Vector2i(15, 4) : 7,
	Vector2i(0, 10) : 8,
	Vector2i(5, 10) : 9,
	Vector2i(10, 10) : 10,
	Vector2i(15, 10) : 11,
}

var atlas_texture = preload("res://assets/world/tree.png")  # Preload the atlas texture


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.connect("change_to_sprites", change)

# Define regions manually based on sprite positions in the sheet
func set_sprite_by_index(index: int, sprite : Sprite2D):
	if index >= 0 and index < sprite_regions.size():
		# Create a new AtlasTexture for each sprite to avoid shared state issues
		var new_atlas_texture = AtlasTexture.new()
		new_atlas_texture.atlas = atlas_texture  # Set the atlas directly
		new_atlas_texture.region = sprite_regions[index]  # Set the specific region for this sprite
		sprite.texture = new_atlas_texture
		sprite.z_index = 1
		sprite.y_sort_enabled = true
	else:
		print("Invalid index!")

func change(selected_tile, atlas_coord):
	var sprite2d = Sprite2D.new() 
	var offset_y = 0
	if atlas_coord.y == 0:
		offset_y = 48
	elif atlas_coord.y == 4:
		offset_y = 80

	elif atlas_coord.y == 10:
		offset_y = 96
		
	sprite2d.position = selected_tile
	sprite2d.offset =   Vector2(0, -offset_y )


	set_sprite_by_index(dict[atlas_coord], sprite2d)
	add_child(sprite2d)
