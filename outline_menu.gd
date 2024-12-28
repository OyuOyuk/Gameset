extends TileMap

# Assuming each tile is a chunk, and the chunk size is 16x16 (or whatever your tile size is)
var hex_size = Vector2(32, 32)  # Example hex tile size, adjust accordingly


func _input(event):
	if event is InputEventMouseButton and event.pressed:	
		
		if  Input.is_action_just_pressed("Right_Click"):  # Left mouse button click
			var global_clicked  = get_local_mouse_position()
			var pos_clicked = local_to_map(to_local(global_clicked))
			
			print(WorldManager.get_chunk(pos_clicked).biome)
			# Convert mouse position to tile position (world_to_map accounts for hex grid)
	
