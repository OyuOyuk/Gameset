extends Node2D
@export var biomeNoise :NoiseTexture2D
@export var tilemap : TileMap
@export var displayTilemap : TileMap

var size = Vector2i(100, 100)
# Define the terrain mapping
var lakeCount = 8
var terrain = {
	"GRASSLANDS": Vector2i(0, 0),
	"FOREST": Vector2i(3, 0),
	"SAND": Vector2i(6, 0)
}
var tiles ={
	
}

func _ready():
	print("Starting map generation...")
	mapGenerator()
	print("Map generation complete, now drawing the map...")
	mapDrawer()
	print("Map drawing complete.")
	print("Display cell set for river.")

func mapGenerator():
	print("Generating map...")
	var noise = biomeNoise.noise
	var tile
	var lakeOptions = []
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			WorldManager.generate_chunk(Vector2i(x,y))
			WorldManager.get_chunk(Vector2i(x,y)).river_connection = [0, 0, 0, 0, 0, 0]
			lakeOptions.append(Vector2i(x,y))
	for time in range(lakeCount):
		randomize()
		WorldManager.get_chunk(lakeOptions.pick_random()).lake = true

	for xs in range(-size.x/2, size.x/2):
		for ys in range(-size.y/2, size.y/2):
			var random_seed = int(str(WorldManager.get_seed()).substr(0, 2)) 
			var tileData = WorldManager.get_chunk(Vector2i(xs, ys))
			var biome_noise = noise.get_noise_2d(xs+random_seed, ys-random_seed)
			if biome_noise >=0.1:
				tileData.biome = "FOREST"
			if biome_noise <-0.1:
				tileData.biome = "GRASSLANDS"
			if biome_noise < -0.3:
				tileData.biome = "SAND"
			if biome_noise < -0.4:
				tileData.biome = "WATER"

	print("Biome mapping complete.")

func mapSetup():
	print("Setting up map...")
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			var tileData = WorldManager.get_chunk(Vector2i(x, y))
			if tileData.biome == "GRASSLANDS":
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			elif tileData.biome == "FOREST":
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif tileData.biome == "DESERT":
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(2, 0))
	print("Map setup complete.")

func mapDrawer():
	print("Drawing map...")
	# Draw the biomes in order (Grasslands -> Forest -> Desert)
	var biome_order = [ "WATER", "SAND","FOREST","GRASSLANDS" ]

	# Iterate through each biome in the order
	for biome in biome_order:
		# Iterate through the entire map
		for x in range(-size.x/2, size.x/2):
			for y in range(-size.y/2, size.y/2):
				var tileData = WorldManager.get_chunk(Vector2i(x, y))
				# Check if the tile matches the current biome type
				if tileData.biome == biome:
					randomize()
					var random_binary = randi() % 2
					# Map the biome to the corresponding tile index for the displayTilemap
					if biome == "GRASSLANDS":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(0, 0)) # Grasslands tile
					elif biome == "FOREST":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(3, 0)) # Forest tile
					elif biome == "SAND":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(6, 0)) # Desert tile
					elif biome == "WATER":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(9, 0)) # Desert tile


