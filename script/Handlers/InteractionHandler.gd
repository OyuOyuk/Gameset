extends Node2D
@onready var master_drop = load("res://inventory/item_drops/master_drop_table.tres")

var bow_shooting = false
var inventory 
var current_chunk = WorldManager.get_current_chunk()
var core_drops = {}
var extra_drops = {}
var drops = []
func _ready():
	for drop in master_drop.object_drops:
		core_drops[drop.name] = drop.core_drops
		extra_drops[drop.name] = drop.extra_drops

	print(core_drops)
	ConnectionManager.connect("new_chunk_entered", new_chunk_handler)
	#for pos in touched_tiles:
		#print("Tile at ", pos, " is ", touched_tiles[pos])
func new_chunk_handler(new_chunk):
	current_chunk = WorldManager.get_current_chunk()
func replace_chop_tree(selected_tile, tool, tilemap):
	var atlas_coord = tilemap.get_cell_atlas_coords(1, selected_tile)
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
				replace_chop_tree(selected_tile, tool , tilemap["trees"])
			else:
				
				chop_tree(selected_tile, tool, tilemap["trees"])
		elif WorldManager.get_tile( current_chunk, selected_tile).object.plant != null:
			var tile_map
			match WorldManager.get_tile( current_chunk, selected_tile).object.plant.plant_type :
				"flower":
					tile_map = tilemap["flowers"]
				"plant":
					tile_map = tilemap["plants"]
				"grass":
					tile_map = tilemap["trees"]
			chop(selected_tile, tool, tile_map)
	elif tool.property.tool_type == "pickaxe":
		pass
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
func use(held_item, slot_index):
	print(held_item.name)
	if held_item.property.consumable == true:
		inventory.slots[slot_index].amount = inventory.slots[slot_index].amount - 1
		if inventory.slots[slot_index].amount == 0:
				inventory.slots[slot_index].item = null
		inventory.update_everything()
	if held_item.property is Food_Properties:
		consume(held_item)
	elif held_item.property is Weapon_Properties:
		#weapon_type(held_item)
		pass

#func weapon_type(held_item):
	#
	#match held_item.property.weapon_type:
		#"bow":
			#handle_bow_use(held_item)
		#"sword":
			#handle_sword_use(held_item)
#func handle_bow_use(held_item):
	#if bow_shooting == false:
		#ConnectionManager.emit_signal("camera_changer", "bow")
		#bow_shooting = true
	#else:
		#ConnectionManager.emit_signal("shoot_bow", get_parent().position, held_item)
func handle_sword_use(held_item):
	pass
func consume(held_item):
	var hunger_value = held_item.property.food_value
	StatsManager.update_hunger(hunger_value)
	print(held_item.name)
func pick(selected_tile, tilemap):
	var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	var object = tile.object.object_id
	if object in core_drops:
		drops = core_drops[object]
	elif object not in core_drops and tile.object.plant != null:
		drops = core_drops["generic_plant"]	
	for item in drops:
		var random_amount= randf_range(item.min_amount , item.max_amount )
		if randf() <= item.item_chance:
			ConnectionManager.emit_signal("player_collect", item.item, random_amount)
	tile.object.plant.growth_stage = 3
	tile.object.interactable = false
	if tile.object.plant.plant_type == "plant":
		tile.object.plant.atlas_coords = Vector2i(tile.object.plant.growth_stage*2, VariablesManager.plant_coords[tile.object.plant.name]*2)
		
		tilemap.set_cell(1, selected_tile, 3, tile.object.plant.atlas_coords)
	elif tile.object.plant.plant_type == "flower":
		tile.object.plant.atlas_coords = Vector2i(tile.object.plant.growth_stage*2, VariablesManager.flower_coords[tile.object.plant.name]*2)
		tilemap.set_cell(1, selected_tile, tile.object.plant.sprite_variant, tile.object.plant.atlas_coords)	

func item_handler(selected_tile, coord):
	var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	var object = tile.object.object_id
	print(object, " is destroyed")
	if object in core_drops:
		for item in core_drops[object]:
			if randf() <= item.item_chance:
				var random_amount= randf_range(item.min_amount , item.max_amount )
				ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
		for item in extra_drops[object]:
			if randf() <= item.item_chance:
				var random_amount= randf_range(item.min_amount , item.max_amount )
				ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
	else:
		if tile.object.plant != null:
			for item in core_drops["generic_plant"]:
				if randf() <= item.item_chance:
					var random_amount= randf_range(item.min_amount , item.max_amount )
					ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
			for item in extra_drops["generic_plant"]:
				if randf() <= item.item_chance:
					var random_amount= randf_range(item.min_amount , item.max_amount )
					ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
#func item_handler(selected_tile, coord):
	#var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	#var object = tile.object.object_id
	#print(object)
	#if object in core_drops:
		#drops = [core_drops[object], extra_drops[object]]
		#
	#elif object not in core_drops and tile.object.plant != null:
		#drops = [core_drops["generic_plant"],core_drops["generic_plant"]]
	#if tile.object.plant != null:
		#if tile.object.plant.growth_stage <= 3:
			#drops = [core_drops["generic_plant"],core_drops["generic_plant"]]
			#
	#for item in drops[0]:
		#print(item)
		#if randf() <= item.item_chance:
			#var random_amount= randf_range(item.min_amount , item.max_amount )
			#ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
	#for item in drops[1]:
		#if randf() <= item.item_chance:
			#var random_amount= randf_range(item.min_amount , item.max_amount )
			#ConnectionManager.emit_signal("direct_item_drops", item.item, random_amount, coord )
