extends Node2D
@onready var master_drop = load("res://inventory/item_drops/master_drop_table.tres")

var current_chunk = WorldManager.get_current_chunk()
var drop_dict = {}
var drops = []
func _ready():
	for drop in master_drop.object_drops:
		drop_dict[drop.name] = drop.drops

	print(drop_dict)
	ConnectionManager.connect("new_chunk_entered", new_chunk_handler)
	#for pos in touched_tiles:
		#print("Tile at ", pos, " is ", touched_tiles[pos])
func new_chunk_handler(new_chunk):
	current_chunk = WorldManager.get_current_chunk()
func replace_chop_tree(selected_tile, tool, tilemap):
	var atlas_coord =tilemap.get_cell_atlas_coords(1, selected_tile)
	tilemap.erase_cell(1, selected_tile)
	print("worked")
	var tile = WorldManager.get_tile( current_chunk, selected_tile)
	tile.object.tree.turned_sprite = true
	tile.object.tree.health = tile.object.tree.health - VariablesManager.tool_material_damage[tool.property.tool_material]
	var non_tile_coord = tilemap.map_to_local(selected_tile)
	ConnectionManager.emit_signal("change_to_sprites", non_tile_coord, atlas_coord, selected_tile)
func chop_tree(selected_tile, tool, tilemap):
	var tile = WorldManager.get_tile( current_chunk, selected_tile)
	var non_tile_coord = tilemap.map_to_local(selected_tile)
	tile.object.tree.health = tile.object.tree.health - VariablesManager.tool_material_damage[tool.property.tool_material]
	if tile.object.tree.health <= 0 and tile.object.tree.chopped == false :
		print("working")
		tile.object.tree.chopped = true
		
		#ConnectionManager.emit_signal("broken_object_drops", selected_tile, non_tile_coord )
		item_handler(selected_tile, non_tile_coord)
		ConnectionManager.emit_signal("chopped_tree", selected_tile, get_parent().position)
	if tile.object.tree.chopped == true and tile.object.tree.health <= -40:
		item_handler(selected_tile, non_tile_coord)
		#ConnectionManager.emit_signal("broken_object_drops", selected_tile, non_tile_coord )
		WorldManager.get_tile( current_chunk, selected_tile).object = null
		tilemap.erase_cell(0, selected_tile)
func right_tool(selected_tile, tool, tilemap):

	if tool.property.tool_type == "axe":
		if WorldManager.get_tile( current_chunk, selected_tile).object.tree != null:
			if WorldManager.get_tile( current_chunk, selected_tile).object.tree.turned_sprite == false:
				print("choping")
				replace_chop_tree(selected_tile, tool , tilemap)
			else:
				
				chop_tree(selected_tile, tool, tilemap)
		elif WorldManager.get_tile( current_chunk, selected_tile).object.plant != null:
			chop(selected_tile, tool, tilemap)
func chop(selected_tile, tool, tilemap):
	var tile = WorldManager.get_tile( current_chunk, selected_tile)
	var non_tile_coord = tilemap.map_to_local(selected_tile)
	tile.object.plant.health = tile.object.plant.health - VariablesManager.tool_material_damage[tool.property.tool_material]
	if tile.object.plant.health <= 0 :
		
		item_handler(selected_tile, non_tile_coord)
		if WorldManager.get_tile( current_chunk, selected_tile).object.plant.plant_type == "flower":
			VariablesManager.flower_tiles[WorldManager.get_current_chunk()].erase(selected_tile)
		elif WorldManager.get_tile( current_chunk, selected_tile).object.plant.plant_type == "plant":
			VariablesManager.plant_tiles[WorldManager.get_current_chunk()].erase(selected_tile)
		WorldManager.get_tile( current_chunk, selected_tile).object = null
		tilemap.erase_cell(1, selected_tile)
func interact(selected_tile, tilemap):
	print("interact")
	if WorldManager.get_tile(current_chunk, selected_tile).object.plant != null:
		pick(selected_tile, tilemap)
func pick(selected_tile, tilemap):
	var non_tile_coord = tilemap.map_to_local(selected_tile)
	var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	var object = tile.object.object_id
	if object in drop_dict:
		drops = drop_dict[object]
	elif object not in drop_dict and tile.object.plant != null:
		drops = drop_dict["generic_plant"]
	for item in drops:
		var random_amount= randf_range(item.min_amount , item.max_amount )
		if randf() <= item.item_chance:
			if item.item.property  is Material_Properties:
				var material_prop = item.item.property as  Material_Properties
				if material_prop.Material_type == "scrap_material":
					continue
				else:
					ConnectionManager.emit_signal("player_collect", item.item, random_amount)
			else:
				ConnectionManager.emit_signal("player_collect", item.item, random_amount)
				
		tile.object.plant.growth_stage = 3
		tile.object.interactable = false
		if tile.object.plant.plant_type == "plant":
			tile.object.plant.atlas_coords = Vector2i(tile.object.plant.growth_stage*2, VariablesManager.plant_coords[tile.object.plant.name]*2)
			
			tilemap.set_cell(1, selected_tile, 3, tile.object.plant.atlas_coords)
		elif tile.object.plant.plant_type == "flower":
			tile.object.plant.atlas_coords = Vector2i(tile.object.plant.growth_stage*2, VariablesManager.flower_coords[tile.object.plant.name]*2)
			tilemap.set_cell(1, selected_tile, tile.object.plant.sprite_variant, tile.object.plant.atlas_coords)	
		#if item.item.property is Food_Properties:
			#pass
func item_handler(selected_tile, coord):
	var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	var object = tile.object.object_id
	print(object)
	if object in drop_dict:
		drops = drop_dict[object]
		print(drops)
	elif object not in drop_dict and tile.object.plant != null:
		drops = drop_dict["generic_plant"]
	if tile.object.plant != null:
		if tile.object.plant.growth_stage <= 3:
			drops = drop_dict["generic_plant"]
			
	for item in drops:
		if randf() <= item.item_chance:
			var random_amount= randf_range(item.min_amount , item.max_amount )
			ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
