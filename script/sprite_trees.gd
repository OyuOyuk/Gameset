extends Node2D
var sprite_regions = [
	Rect2(0, 0, 160, 160),   # First sprite
	Rect2(160, 0, 160, 160), # Second sprite (different height)
	Rect2(320, 0, 160, 160), # Third sprite
	Rect2(480, 0, 160, 160),
	Rect2(0, 160, 160, 224),   # First sprite
	Rect2(160, 160, 160,224), # Second sprite (different height)
	Rect2(320, 160, 160, 224),
	Rect2(480, 160, 160, 224),
	Rect2(0, 384, 160, 256),   # First sprite
	Rect2(160, 384, 160, 256), # Second sprite (different height)
	Rect2(320, 384, 160, 256),
	Rect2(480, 384, 160, 256),
	# Add more as needed
]

var dict = {
	Vector2i(0, 0) : 0,
	Vector2i(5, 0) : 1,
	Vector2i(10, 0) : 2,
	Vector2i(15, 0) : 3,
	Vector2i(0, 5) : 4,
	Vector2i(5, 5) : 5,
	Vector2i(10, 5) : 6,
	Vector2i(15, 5) : 7,
	Vector2i(0, 12) : 8,
	Vector2i(5, 12) : 9,
	Vector2i(10, 12) : 10,
	Vector2i(15, 12) : 11,
}

var atlas_texture = preload("res://assets/world/trees/fixed_tree_tops.png")  # Preload the atlas texture


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.connect("change_to_sprites", change)
	ConnectionManager.connect("chopped_tree", delete)
# Define regions manually based on sprite positions in the sheet
func set_sprite_by_index(atlas_coord, sprite : Sprite2D):
	if atlas_coord != null:
		var new_atlas_texture = AtlasTexture.new()
		
		new_atlas_texture.atlas = atlas_texture  # Set the atlas directly
		#new_atlas_texture.region = sprite_regions[index]  # Set the specific region for this sprite
		new_atlas_texture.region = Rect2(atlas_coord.x / 5 * 160, atlas_coord.y / 8* 256 ,160, 256)

		sprite.texture = new_atlas_texture
		sprite.z_index = 1
		sprite.y_sort_enabled = true
	else:
		print("Invalid index!")
func delete(selected_tile, player_coord):
	var del = get_node_or_null(str(selected_tile))
	var rotate = -90
	if del:
		if del.position.x >= player_coord.x:
			rotate = 90
		else:
			rotate = -90
		var tween = del.create_tween()
		tween.tween_interval(0.5)
		# Rotate the tree to simulate falling
		tween.tween_property(del, "rotation_degrees", rotate, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
		# Move the tree slightly to simulate it hitting the ground
		tween.tween_property(del, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

		# After animation ends, delete the node
		tween.finished.connect(del.queue_free)

func change(selected_coord, atlas_coord, selected_tile):
	var sprite2d = Sprite2D.new() 
	var offset_y = 112
		
	sprite2d.position = selected_coord
	sprite2d.offset =   Vector2(0, - offset_y )
	sprite2d.name = str(selected_tile)


	set_sprite_by_index(atlas_coord, sprite2d)
	add_child(sprite2d)
