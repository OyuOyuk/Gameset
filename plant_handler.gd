extends Node2D


var current_chunk
var flower_tiles
var plant_tiles
var growth_stage_number = 3
var forageTilemaps = {
	
}

@export var tile_map : TileMap
@onready var plant_tilemaps = get_tree().get_nodes_in_group("plant_tilemaps")
# Called when the node enters the scene tree for the first time.
func _ready():
	for plant_tilemap in plant_tilemaps:
		forageTilemaps[plant_tilemap.name] = plant_tilemap	
	ConnectionManager.connect("day_change",growth_handler )
	ConnectionManager.connect("new_chunk_entered", new_chunk_handler)
func new_chunk_handler(new_chunk):
	if WorldManager.get_tile(new_chunk, Vector2i(0, 0)) != null:
		current_chunk = new_chunk
		flower_tiles = VariablesManager.flower_tiles[current_chunk]
		plant_tiles = VariablesManager.plant_tiles[current_chunk]
		var tiles_to_update = plant_tiles + flower_tiles
		for tile in tiles_to_update:
			
			var tile_data = WorldManager.get_tile(current_chunk, tile).object.plant
			if tile_data.growth_stage > 3:
				WorldManager.get_tile(current_chunk, tile).object.interactable == true
			if (TimeManager.total_days - tile_data.last_date_updated) >  VariablesManager.growth_time[tile_data.name]:
				if tile_data.blossomable == true  or tile_data.fruitable == true:
					growth_stage_number = 5

				var stages_to_advance = floor((TimeManager.total_days - tile_data.last_date_updated) / VariablesManager.growth_time[tile_data.name])
				var chances = (stages_to_advance + tile_data.growth_stage) - growth_stage_number
				
				tile_data.growth_stage = min(tile_data.growth_stage + stages_to_advance, growth_stage_number)
				tile_data.days_elapsed = (TimeManager.total_days - tile_data.last_date_updated) % VariablesManager.growth_time[tile_data.name]
				tile_data.last_date_updated = TimeManager.total_days
				if tile_data.plant_type == "flower":
					tile_data.atlas_coords = Vector2i(tile_data.growth_stage*2, VariablesManager.flower_coords[tile_data.name]*2)
				elif tile_data.plant_type == "plant":
					tile_data.atlas_coords = Vector2i(tile_data.growth_stage*2, VariablesManager.plant_coords[tile_data.name]*2)
				for i in range(chances):
					var spread_chance = VariablesManager.spread_chance[tile_data.name]
					if randf() < spread_chance:
						try_spread(tile_data.name ,tile, current_chunk)
				if chances >= VariablesManager.wither_time[tile_data.name]:
					wither(tile,tile_data.plant_type,  current_chunk)
				#if tile_data.growth_stage == growth_stage_number:
					#var spread_chance = VariablesManager.spread_chance[tile_data.name]
					#if randf() < spread_chance:
						#try_spread(tile_data.name ,tile, current_chunk)
		tilemap_updater(current_chunk)
func dict_cleaner():
	var current_chunk = WorldManager.get_current_chunk()
	for pos in VariablesManager.plant_tiles[current_chunk]:
		if WorldManager.get_tile(current_chunk, pos).object == null:

			VariablesManager.plant_tiles[current_chunk].erase(pos)
		else:
			if WorldManager.get_tile(current_chunk, pos).object.plant == null:
				VariablesManager.plant_tiles[current_chunk].erase(pos)
	for pos in VariablesManager.flower_tiles[current_chunk]:
		if WorldManager.get_tile(current_chunk, pos).object == null:
			VariablesManager.flower_tiles[current_chunk].erase(pos)
		else:
			if WorldManager.get_tile(current_chunk, pos).object.plant == null:
				VariablesManager.plant_tiles[current_chunk].erase(pos)
func growth_handler():
	print("growing")
	current_chunk = WorldManager.get_current_chunk()
	flower_tiles = VariablesManager.flower_tiles[current_chunk]
	plant_tiles = VariablesManager.plant_tiles[current_chunk]
	var tiles_to_update = plant_tiles + flower_tiles
	
	for tile in tiles_to_update:
		
		var tile_data = WorldManager.get_tile(current_chunk, tile).object.plant
		if tile_data == null:
			continue
		if tile_data.blossomable == true or tile_data.fruitable == true:
			growth_stage_number = 5
		tile_data.days_elapsed = tile_data.days_elapsed + 1
		if tile_data.name == "grass":
			print("cleaning!")
			dict_cleaner()
			continue

		
		if tile_data.days_elapsed >= VariablesManager.growth_time[tile_data.name]:

			tile_data.days_elapsed = 0
		
			
			tile_data.growth_stage = min(tile_data.growth_stage + 1, growth_stage_number)
			if tile_data.plant_type == "flower":
				
				tile_data.atlas_coords = Vector2i(tile_data.growth_stage*2, VariablesManager.flower_coords[tile_data.name]*2)
			elif tile_data.plant_type == "plant":
				tile_data.atlas_coords = Vector2i(tile_data.growth_stage*2, VariablesManager.plant_coords[tile_data.name]*2)
			if tile_data.growth_stage >= growth_stage_number:
				var spread_chance = VariablesManager.spread_chance[tile_data.name]

				if randf() < spread_chance:
					try_spread(tile_data.name ,tile, current_chunk)
				if TimeManager.total_days - tile_data.last_date_updated >= VariablesManager.wither_time[tile_data.name]:
					wither(tile, tile_data.plant_type ,current_chunk)
			else:
				tile_data.last_date_updated = TimeManager.total_days
	tilemap_updater(current_chunk)
	print("work!")
func wither(pos, type, current_chunk):
	var tile = WorldManager.get_tile(current_chunk, pos ).object.plant
	if tile.plant_type == "flower":

		VariablesManager.flower_tiles[current_chunk].erase(pos)
		tile_map.erase_cell(1, pos)
	if tile.plant_type == "plant":

		VariablesManager.plant_tiles[current_chunk].erase(pos)
		tile_map.erase_cell(1, pos)
	WorldManager.get_tile(current_chunk, pos ).object = null

func try_spread(plant_name, pos, current_chunk):
	var directions = [ Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1),Vector2i(0, -1)]		
	directions.shuffle()
	for dir in directions:
		var new_pos = pos + dir
		var tile = WorldManager.get_tile(current_chunk, new_pos)
		if tile == null:
			continue
		if tile.object == null:
			var plant_data = PlantData.new()
			var object = objectData.new()
			var y
			plant_data.name = plant_name
			plant_data.growth_stage = 0
			plant_data.health = 20
			plant_data.sprite_variant = randi() %2
			object.object_id = plant_name
			WorldManager.get_tile(current_chunk, new_pos).breakable_object = plant_name
			if plant_name in VariablesManager.flower_types:
				y = VariablesManager.flower_coords[plant_name]
				plant_data.plant_type = "flower"
				plant_data.blossomable = VariablesManager.bloomable[plant_name]
				VariablesManager.flower_tiles[current_chunk].append(new_pos)
			else:
				y = VariablesManager.plant_coords[plant_name]
				plant_data.plant_type = "plant"
				plant_data.fruitable = VariablesManager.fruitable[plant_name]
				VariablesManager.plant_tiles[current_chunk].append(new_pos)
			plant_data.atlas_coords = Vector2i(0, y*2)
			object.plant = plant_data
			object.broken_by = ["axe"]
			WorldManager.get_tile(current_chunk, new_pos ).object = object
			break
func tilemap_updater(current_chunk):
	flower_tiles = VariablesManager.flower_tiles[current_chunk]
	
	plant_tiles = VariablesManager.plant_tiles[current_chunk]

	for tile in flower_tiles :
		var tile_data = WorldManager.get_tile(current_chunk, tile)
		if tile_data.object.plant.growth_stage >= 4:
			tile_data.object.interactable = true
			
		#print(WorldManager.get_tile(current_chunk, tile).object.plant)
		forageTilemaps["flowers"].set_cell(1, tile, tile_data.object.plant.sprite_variant, tile_data.object.plant.atlas_coords)
	for tile in plant_tiles:
		var tile_data = WorldManager.get_tile(current_chunk, tile)
		if tile_data.object.plant.growth_stage >= 4:
			tile_data.object.interactable = true
		#print(WorldManager.get_tile(current_chunk, tile).object.plant)
		tile_map.set_cell(1, tile, 3, tile_data.object.plant.atlas_coords)

