extends Node2D

@export var LandNoise :NoiseTexture2D
@export var WaterNoise :NoiseTexture2D

@export var world : TileMap
@export var water : TileMap
@export var objects : TileMap
enum type { GRASS, DIRT }

var noise : Noise
var water_noise : Noise
var size  = VariablesManager.chunkSize
var rule = {
	"road" : ["road", "house_plot", "park"],
	"house_plot": ["road"],
	"park" : ["park", "road"]
}	
var tree_amount = {
	"FOREST": 150,
	"GRASSLANDS":20,
	"SAND":0,
	"WATER":0, 
}
var grass_amount = {
	"FOREST": 400,
	"GRASSLANDS":500,
	"SAND":0,
	"WATER":0, 
}
var values = {
	"GRASSLANDS" : -0.3,
	"FOREST" : -0.1,
	"SAND" : -0.2
}


@onready var script_a = $world
@onready var script_b = $water

func _ready():
	print(find_hexagon_midpoints())
	noise = LandNoise.noise
	water_noise = WaterNoise.noise
	var current_chunk = Vector2i(0, 0)
	new_chunk(current_chunk)
	ConnectionManager.new_map_position.connect(new_chunk)
func new_chunk(current_chunk):
	if WorldManager.get_tile(current_chunk, Vector2i(0, 0)) == null:
		objects.clear()
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
			 	
				if WorldManager.get_tile(current_chunk, pos +Vector2i(dx, dy)) != null:
					WorldManager.get_tile(current_chunk, pos +Vector2i(dx, dy)).waterPrescence = true
				
		if radius < 6 :
			radius = radius + randi() % 4
		else:
			radius =  radius - randi() % 4
		pos += direction
	
	# Ensure the endpoint is marked
	if WorldManager.get_tile(current_chunk, pos) != null:
		WorldManager.get_tile(current_chunk, pos).waterPrescence = true
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

			WorldManager.generate_tile(current_chunk,Vector2i(x,y))

			if terrain_noise_val >= values[WorldManager.get_chunk(current_chunk).biome]:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType = type.GRASS
			else:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType = type.DIRT
			
			tile_choices.append(Vector2i(x,y))
		if y > 0:
			minx = minx + 0.5
		else:
			minx = minx - 0.5

	if WorldManager.get_chunk(current_chunk).lake == true:
		generate_lake(Vector2i(0, 0),40,current_chunk)
	if WorldManager.get_chunk(current_chunk).river_connection != [0,0,0,0,0,0]:
		set_river_flow(current_chunk )
	if WorldManager.get_chunk(current_chunk).biome != "WATER":
		tree(current_chunk, tile_choices)
		grass(current_chunk, tile_choices)
func grass(current_chunk, tile_choices):
	for time in range(grass_amount[WorldManager.get_chunk(current_chunk).biome]):
		var grass_pos = tile_choices.pick_random()
		if WorldManager.get_tile(current_chunk,grass_pos ).waterPrescence == false and WorldManager.get_tile(current_chunk,grass_pos ).tree == null :
			var grass_data = PlantData.new()
			var random_number_x = randi() % 2 * 2
			WorldManager.get_tile(current_chunk,grass_pos).breakable_object = "grass"
			grass_data.atlas_coords = Vector2i(random_number_x, 0)
			WorldManager.get_tile(current_chunk,grass_pos ).plant = grass_data

func tree(current_chunk,tile_choices):
	#
	var spawned_tree_positions = []
	var min_distance_squared = 3 * 3   # Minimum distance between trees
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
		if WorldManager.get_tile(current_chunk,tree_pos ).waterPrescence == false :
			var tree_data = PlantData.TreeData.new()
			var random_number_x = randi() % 4 * 5
			var trunk 
			var trunk_y = 0
			var random_number_y = randi() % 3
			tree_data.growth_stage = random_number_y + 1
			match random_number_y:
				0:
					random_number_y = 0
					trunk = 0
					tree_data.growth_stage = 1
				1: 
					random_number_y = 4
					trunk = 3
					tree_data.growth_stage = 2
				2: 
					random_number_y = 10
					trunk = 6
					tree_data.growth_stage = 3
			if random_number_x < 8:
				trunk_y = 2
			tree_data.atlas_coords = Vector2i(random_number_x, random_number_y)
			tree_data.root_atlas_coords = Vector2i(trunk, trunk_y)
			WorldManager.get_tile(current_chunk,tree_pos ).tree = tree_data
			WorldManager.get_tile(current_chunk,tree_pos ).breakable_object = "tree"
			spawned_tree_positions.append(tree_pos)
			tree_to_spawn = tree_to_spawn - 1
func generateWorld(current_chunk):
	var minx = -size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(minx, -minx):
			
			if WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType == type.GRASS :
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType == type.DIRT:
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			if WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence == true:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence == false:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			
			if WorldManager.get_tile(current_chunk, Vector2i(x,y)).tree != null:
				objects.set_cell(1,Vector2i(x,y),0,WorldManager.get_tile(current_chunk, Vector2i(x,y)).tree.atlas_coords)
				objects.set_cell(0,Vector2i(x,y),1,WorldManager.get_tile(current_chunk, Vector2i(x,y)).tree.root_atlas_coords)
			elif WorldManager.get_tile(current_chunk, Vector2i(x,y)).plant != null:
				objects.set_cell(1,Vector2i(x,y),2,WorldManager.get_tile(current_chunk, Vector2i(x,y)).plant.atlas_coords)
				
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
		
		
	

