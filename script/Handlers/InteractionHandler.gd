extends Node2D

var current_chunk = WorldManager.get_current_chunk()
func replace_chop(selected_tile, tool, tilemap):
	var atlas_coord =tilemap.get_cell_atlas_coords(1, selected_tile)
	tilemap.erase_cell(1, selected_tile)
	print("worked")
	WorldManager.get_tile( current_chunk, selected_tile).tree.turned_sprite = true
	WorldManager.get_tile( current_chunk, selected_tile).tree.health = WorldManager.get_tile( current_chunk, selected_tile).tree.health - VariablesManager.tool_material_damage[tool.property.tool_material]
	var non_tile_coord = tilemap.map_to_local(selected_tile)
	ConnectionManager.emit_signal("change_to_sprites", non_tile_coord, atlas_coord, selected_tile)
func chop(selected_tile, tool, tilemap):
	
	WorldManager.get_tile( current_chunk, selected_tile).tree.health = WorldManager.get_tile( current_chunk, selected_tile).tree.health - VariablesManager.tool_material_damage[tool.property.tool_material]
	if WorldManager.get_tile(current_chunk, selected_tile).tree.health <= 0:
		print("working")
		WorldManager.get_tile(current_chunk, selected_tile).tree.chopped = true
		var non_tile_coord = tilemap.map_to_local(selected_tile)
		ConnectionManager.emit_signal("broken_object_drops", selected_tile, non_tile_coord )
		ConnectionManager.emit_signal("chopped_tree", selected_tile, get_parent().position)
func right_tool(selected_tile, tool, tilemap):
	if tool.property.tool_type == "axe":
		if WorldManager.get_tile( current_chunk, selected_tile).tree.turned_sprite == false:
			print("choping")
			replace_chop(selected_tile, tool , tilemap)
		else:
			
			chop(selected_tile, tool, tilemap)
