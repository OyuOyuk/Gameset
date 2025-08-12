extends Node2D

@export var LandNoise :NoiseTexture2D
@export var WaterNoise :NoiseTexture2D

@export var world : TileMap
@export var water : TileMap
@export var objects : TileMap
enum type { GRASS, DIRT }
var forageTilemaps = {
	
}
var objectTilemaps = {
	
}
@onready var plant_tilemaps = get_tree().get_nodes_in_group("plant_tilemaps")
@onready var object_tilemaps = get_tree().get_nodes_in_group("object_tilemaps")
var noise : Noise
var water_noise : Noise
@onready var size  = VariablesManager.chunkSize
@onready var rule = VariablesManager.rule
@onready var tree_amount = VariablesManager.tree_amount
@onready var grass_amount = VariablesManager.grass_amount
@onready var plant_amount = VariablesManager.plant_amount
@onready var values = VariablesManager.values
@onready var items_onground = VariablesManager.onground_items

@onready var script_a = $world
@onready var script_b = $water

func _ready():
	print(find_hexagon_midpoints())
	for plant_tilemap in plant_tilemaps:
		forageTilemaps[plant_tilemap.name] = plant_tilemap	
	for object_tilemap in object_tilemaps:
		objectTilemaps[object_tilemap.name] = object_tilemap

	noise = LandNoise.noise
	water_noise = WaterNoise.noise
	var current_chunk = Vector2i(0, 0)
	new_chunk(current_chunk)
	ConnectionManager.new_map_position.connect(new_chunk)
func new_chunk(current_chunk):
	if WorldManager.get_tile(current_chunk, Vector2i(0, 0)) == null:
		VariablesManager.flower_tiles[current_chunk] = []
		VariablesManager.plant_tiles[current_chunk] = []
		VariablesManager.tree_tiles[current_chunk] = []
		for plant_tilemap in plant_tilemaps:
			plant_tilemap.clear()
		assignTiles(current_chunk)
		
		
	generateWorld(current_chunk)
	script_a._ready()
	script_b._ready()
func find_hexagon_midpoints():
	var midpoints = []
	var half_width = size.x / 2  + 0.5*size.y/4
	var half_height = size.y / 2

	# Top-left (adjusted for staggered rows)
	midpoints.append(Vector2i(-half_width, -half_height / 2))  

	# Top-mid (flat edge, no adjustment needed)
	midpoints.append(Vector2i(0, -half_height))               

	# Top-right (adjusted for staggered rows)
	midpoints.append(Vector2i(half_width, -half_height / 2))  

	# Bottom-right (adjusted for staggered rows)
	midpoints.append(Vector2i(half_width, half_height / 2))   

	# Bottom-mid (flat edge, no adjustment needed)
	midpoints.append(Vector2i(0, half_height))               

	# Bottom-left (adjusted for staggered rows)
	midpoints.append(Vector2i(-half_width, half_height / 2))  

	return midpoints


func set_river_flow(current_chunk):
	var river_connection = WorldManager.get_chunk(current_chunk).river_connection
	var midpoints = find_hexagon_midpoints()

	for side in range(river_connection.size()):
		if river_connection[side] == 1:
			draw_river(midpoints[side], current_chunk)
			
func draw_river(start_pos: Vector2i, current_chunk):
	var pos = start_pos
	var radius = 3
	while pos != Vector2i(0, 0):
		var direction = Vector2i.ZERO - pos
		direction.x = direction.x / abs(direction.x) if direction.x != 0 else 0
		direction.y = direction.y / abs(direction.y) if direction.y != 0 else 0
		
		for dx in range(-radius, radius):
			for dy in range(-radius, radius):
				var tile = WorldManager.get_tile(current_chunk, pos +Vector2i(dx, dy))
				if tile != null:
					tile.waterPrescence = true
				
		if radius < 6 :
			radius = radius + randi() % 4
		else:
			radius =  radius - randi() % 4
		pos += direction
	
	# Ensure the endpoint is marked
	var end_tile = WorldManager.get_tile(current_chunk, pos)
	if end_tile != null:
		end_tile.waterPrescence = true
func generate_lake(center: Vector2i, iterations: int,current_chunk):
	var lake_tiles = [center]

	for u in range(iterations):
		var new_tiles = []
		for tile in lake_tiles:
			for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var neighbor = tile + offset
				if not neighbor in lake_tiles and randf() < 0.4:  # Random chance to expand
					new_tiles.append(neighbor)

		lake_tiles += new_tiles

	for tile in lake_tiles:
		WorldManager.get_tile(current_chunk, tile).waterPrescence = true

func assignTiles(current_chunk):
	print("generated ", current_chunk)
	var minx = - size.x/2
	var tile_choices = []
	for y in range(-size.y/2, size.y/2):
		for x in range(minx, -minx):
			var chunk_id = hash(str(current_chunk.x) + str(current_chunk.y))
			var random_seed = int(str(WorldManager.get_seed()).substr(0, 6)) + int(str(chunk_id).substr(3, 7)) # good enough for now
			
			var terrain_noise_val = noise.get_noise_2d(x+random_seed, y+random_seed)
			var biome = WorldManager.get_chunk(current_chunk).biome
			WorldManager.generate_tile(current_chunk,Vector2i(x,y))
			var tile = WorldManager.get_tile(current_chunk,Vector2i(x,y))
			if terrain_noise_val >= values[biome]:
				tile.tileType = type.GRASS
			else:
				tile.tileType = type.DIRT
			if biome == "WATER":
				tile.waterPrescence = true
			tile_choices.append(Vector2i(x,y))
		if y > 0:
			minx = minx + 0.5
		else:
			minx = minx - 0.5
	var chunk = WorldManager.get_chunk(current_chunk)
	if chunk.lake == true:
		generate_lake(Vector2i(0, 0),40,current_chunk)
	if chunk.river_connection != [0,0,0,0,0,0]:
		set_river_flow(current_chunk )
	if chunk.biome != "WATER":
		#tree(current_chunk, tile_choices)
		tree(current_chunk, tile_choices)
		plants(current_chunk, tile_choices)
		#grass(current_chunk, tile_choices)
		flowers(current_chunk, tile_choices)
		rock(current_chunk, tile_choices)
func land_item(current_chunk, tile_choices):
	for time in range(items_onground[WorldManager.get_chunk(current_chunk).biome]):
		var item_pos = tile_choices.pick_random()
		if WorldManager.get_tile(current_chunk, item_pos ).waterPrescence == false and  WorldManager.get_tile(current_chunk, item_pos ).object == null:
			var item_coord = world.map_to_local(item_pos)
			ConnectionManager.emit_signal("ground_item_spawn", item_coord)
func plants(current_chunk, tile_choices):
	for time in range(plant_amount[WorldManager.get_chunk(current_chunk).biome]):
		var plant_pos = tile_choices.pick_random()
		if WorldManager.get_tile(current_chunk, plant_pos ).waterPrescence == false and  WorldManager.get_tile(current_chunk, plant_pos ).object == null:
			var plant_data = PlantData.new()
			var object = objectData.new()
			var random = randi() %  VariablesManager.plant_types.size()
			var plant_type = VariablesManager.plant_types[random]
			var y = VariablesManager.plant_coords[plant_type]
			var x = randi() % 4
			
			VariablesManager.plant_tiles[current_chunk].append(plant_pos)
			plant_data.name = plant_type
			plant_data.plant_type = "plant"
			plant_data.growth_stage = x
			plant_data.fruitable = VariablesManager.fruitable[plant_type]
			plant_data.health = 20
			plant_data.atlas_coords = Vector2i(x*2, y*2)
			var tile = WorldManager.get_tile(current_chunk, plant_pos)
			tile.breakable_object = plant_type
			object.broken_by = ["axe"]
			object.plant = plant_data
			object.object_id = plant_type
			tile.object = object
			
			#tile.plant =plant_data #old
func flowers(current_chunk, tile_choices):
	for time in range(plant_amount[WorldManager.get_chunk(current_chunk).biome]/100):
		var plant_pos = tile_choices.pick_random()
		
		

		var random = randi() %  VariablesManager.flower_types.size()
		var plant_type = VariablesManager.flower_types[random]
		var size = randi_range(VariablesManager.flower_circle_size[plant_type][0], VariablesManager.flower_circle_size[plant_type][1]) 
		flowers_circle(plant_pos, size, current_chunk, plant_type)
func flowers_circle(center_position, size, current_chunk, plant_type):
	var flower_tiles = [center_position]

	for u in range(size):
		var new_tiles = []
		for tile in  flower_tiles:
			for offset in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var neighbor = tile + offset
				if not neighbor in flower_tiles and randf() < 0.4:  # Random chance to expand
					new_tiles.append(neighbor)
			
		flower_tiles += new_tiles
	
	for tile in flower_tiles:
		var tile_data = WorldManager.get_tile(current_chunk, tile )
		if tile_data != null:
			if tile_data.waterPrescence == false and tile_data.object == null :
				var plant_data = PlantData.new()
				var object = objectData.new()
				
				
				var y = VariablesManager.flower_coords[plant_type]
				var x = randi() % 4
				plant_data.name = plant_type
				plant_data.growth_stage = x
				plant_data.plant_type = "flower"
				plant_data.health = 20
				plant_data.blossomable = VariablesManager.bloomable[plant_type]
				plant_data.atlas_coords = Vector2i(x*2, y*2)
				plant_data.sprite_variant = randi() % 2
				tile_data.breakable_object = plant_type
				object.broken_by = ["axe"]
				object.plant = plant_data
				object.object_id = plant_type
				tile_data.object = object
				VariablesManager.flower_tiles[current_chunk].append(tile)
				#tile_data.plant =plant_data #old
#func grass(current_chunk, tile_choices):
#
	#for time in range(grass_amount[WorldManager.get_chunk(current_chunk).biome]):
		#var grass_pos = tile_choices.pick_random()
		#var tile_data = WorldManager.get_tile(current_chunk,grass_pos )
		#if tile_data.waterPrescence == false and tile_data.object == null :
			#var grass_data = PlantData.new()
			#var object = objectData.new()
			#var random_number_x = randi() % 2 * 2
			#
			#tile_data.breakable_object = "grass"
			#grass_data.name = "grass"
			#grass_data.plant_type = "grass"
			#grass_data.health = 1
			#grass_data.atlas_coords = Vector2i(random_number_x, 0)
			#object.broken_by = ["axe"]
			#object.plant = grass_data
			#object.object_id = grass_data.name
			#tile_data.object= object
			##tile_data.plant = grass_data #old 
func rock(current_chunk, tile_choices):
	for time in range(100):
		var rock_pos = tile_choices.pick_random()
		var tile_data = WorldManager.get_tile(current_chunk,rock_pos )
		if tile_data.waterPrescence == false and tile_data.object == null :
			var object = objectData.new()
			var x = randi() % 6
			var y = randi() % 3
			object.rock = Vector2i(x*2, y*2)
			tile_data.breakable_object = "rock"
			object.object_id = "rock"
			object.broken_by = ["pickaxe"]
			tile_data.object = object
func tree(current_chunk, tile_choices):
	print("Edit")
	var spawned_tree_positions = []
	var min_distance_squared = 3 * 3
	var tree_to_spawn = tree_amount[WorldManager.get_chunk(current_chunk).biome]
	while tree_to_spawn > 0  and tile_choices.size() > 0:
		var tree_pos = tile_choices.pick_random()
		var too_close = false
		for existing_pos in spawned_tree_positions:
			var distance_squared = (tree_pos.x - existing_pos.x) * (tree_pos.x - existing_pos.x) + (tree_pos.y - existing_pos.y) * (tree_pos.y - existing_pos.y)
			if distance_squared < min_distance_squared:
				too_close = true
				break
		if too_close:
			tile_choices.erase(tree_pos)
			continue
		var  tile = WorldManager.get_tile(current_chunk,tree_pos )
		if tile.waterPrescence == false:
			var object = objectData.new()
			var tree_data = PlantData.TreeData.new()
			var random_tree_type = randi() % 4
			var random_life_stage = randi() % 4 
			VariablesManager.tree_tiles[current_chunk].append(tree_pos)
			tree_data.growth_stage = random_life_stage
			tree_data.atlas_coords = Vector2i(random_tree_type*5, random_life_stage*8)
			tree_data.name = VariablesManager.tree_types[0 if random_tree_type == 0 or random_tree_type == 1 else 1]
			tree_data.plant_type = "tree"
			tree_data.health =100
			object.object_id = tree_data.name
			object.broken_by = ["axe"]
			object.plant = tree_data
			tile.object = object
			spawned_tree_positions.append(tree_pos)
			tree_to_spawn = tree_to_spawn - 1

func generateWorld(current_chunk):
	var minx = -size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(minx, -minx):
			var tile = WorldManager.get_tile(current_chunk,Vector2i(x,y))
			if tile.tileType == type.GRASS :
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif tile.tileType == type.DIRT:
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			if tile.waterPrescence == true:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif tile.waterPrescence == false:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			if tile.object != null:

				if tile.object.plant != null:
					if tile.object.plant.plant_type == "grass":
						objects.set_cell(1,Vector2i(x,y),2,tile.object.plant.atlas_coords)
					elif tile.object.plant.plant_type == "plant":
						forageTilemaps["plants"].set_cell(1,Vector2i(x,y),0,tile.object.plant.atlas_coords)
					elif tile.object.plant.plant_type == "flower":
						forageTilemaps["flowers"].set_cell(1,Vector2i(x,y),tile.object.plant.sprite_variant,tile.object.plant.atlas_coords)
					elif tile.object.plant.plant_type == "tree":
						forageTilemaps["trees"].set_cell(0, Vector2i(x, y), 0, tile.object.plant.atlas_coords)
						forageTilemaps["trees"].set_cell(1, Vector2i(x, y), 1, tile.object.plant.atlas_coords)
						
				elif tile.object.rock != null:
					objectTilemaps["minerals"].set_cell(0, Vector2i(x,y), 0, tile.object.rock )
		if y > 0:
			minx = minx + 0.5
		else:
			minx = minx - 0.5
func city_generation(current_chunk, start, size):
	var size_x = randi() % 11 + 2
	var size_y = randi() % 11 + 2
	for house in size:
		
		size_x = randi() % 11 + 2
		size_y = randi() % 11 + 2
		for x in range(start.x - size_x, start.x + size_x):
			for y in range(start.y - size_y, start.y + size_y):
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).structure_type = "house_plot"
		
		
	

