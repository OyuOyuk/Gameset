extends Node2D
@export var biomeNoise :NoiseTexture2D
@export var tilemap : TileMap
@export var displayTilemap : TileMap
var size = Vector2i(100, 100)
# Define the terrain mapping
var riverStarters = 5
var terrain = {
	"GRASSLANDS": Vector2i(0, 0),
	"FOREST": Vector2i(3, 0),
	"DESERT": Vector2i(6, 0)
}
var tiles ={
	
}
var riverTileSet = {
	"1,0,0,0,1,0":Vector2i(0, 0),
	"1,0,0,1,0,0": Vector2i(1,0),
	"1,0,1,0,0,0": Vector2i(2,0),
	"0,1,0,0,0,1": Vector2i(3,0),
	"0,1,0,0,1,0": Vector2i(4,0),
	"0,1,0,1,0,0": Vector2i(5,0),
	"1,1,0,0,1,0": Vector2i(6,0),
	"1,0,1,0,1,0": Vector2i(7,0),
	"0,1,1,0,1,0": Vector2i(8,0),
	"1,0,0,1,1,0": Vector2i(9,0),
	#"1,0,1,0,1,0": Vector2i(10,0),
	"1,0,1,1,0,0": Vector2i(11,0),
	"1,0,1,0,0,1": Vector2i(12,0),
	"0,0,1,0,1,1": Vector2i(14,0),
	"1,0,1,1,1,0": Vector2i(15,0),
	"1,0,1,0,1,1": Vector2i(16,0),
	"0,0,1,0,0,1": Vector2i(0,1),
	"0,0,1,0,1,0": Vector2i(1,1),
	"0,0,0,1,0,1": Vector2i(2,1),
	"1,1,0,1,0,0": Vector2i(3,1),
	#"0,1,0,1,0,1": Vector2i(4,1),
	"1,0,0,1,0,1": Vector2i(5,1),
	"0,1,1,0,0,1": Vector2i(6,1),
	"0,1,0,1,0,1": Vector2i(7,1),
	"0,0,1,1,0,1": Vector2i(8,1),
	"0,1,0,0,1,1": Vector2i(9,1),
	"0,1,0,1,1,0": Vector2i(11,1),
	"1,1,0,1,0,1": Vector2i(12,1),
	"1,1,1,0,1,0": Vector2i(13,1),
	"0,1,1,1,0,1": Vector2i(14,1),
	"0,1,0,1,1,1": Vector2i(15,1),
	
}
func _ready():
	print("Starting map generation...")
	mapGenerator()
	print("Map generation complete, now drawing the map...")
	mapDrawer()
	print("Map drawing complete.")
	displayTilemap.set_cell(1, riverTileSet[",".join([0, 1, 0, 0, 0, 1])], 3, Vector2i(0, 0))
	print("Display cell set for river.")

func mapGenerator():
	print("Generating map...")
	var noise = biomeNoise.noise
	var tile
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			tile = worldData.new()
			tile.pos = Vector2i(x, y)
			tiles[tile.pos] = tile
	print("Tiles generated. Generating rivers...")
	generateRivers()
	print("Rivers generated.")
	for xs in range(-size.x/2, size.x/2):
		for ys in range(-size.y/2, size.y/2):
			var tileData = tiles[Vector2i(xs, ys)]
			var biome_noise = noise.get_noise_2d(xs, ys)
			if biome_noise >=-0.1:
				tileData.biome = "GRASSLANDS"
			elif biome_noise <-0.1:
				tileData.biome = "FOREST"
			elif biome_noise < -0.3:
				tileData.biome = "DESERT"
	print("Biome mapping complete.")

func mapSetup():
	print("Setting up map...")
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			var tileData = tiles[Vector2i(x,y)]
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
	var biome_order = ["GRASSLANDS", "FOREST", "DESERT"]

	# Iterate through each biome in the order
	for biome in biome_order:
		# Iterate through the entire map
		for x in range(-size.x/2, size.x/2):
			for y in range(-size.y/2, size.y/2):
				var tileData = tiles[Vector2i(x, y)]
				# Check if the tile matches the current biome type
				if tileData.biome == biome:
					randomize()
					var random_binary = randi() % 3
					# Map the biome to the corresponding tile index for the displayTilemap
					if biome == "GRASSLANDS":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(0, 0)) # Grasslands tile
					elif biome == "FOREST":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(3, 0)) # Forest tile
					elif biome == "DESERT":
						displayTilemap.set_cell(0, Vector2i(x, y), random_binary, Vector2i(6, 0)) # Desert tile
				if tileData.river_connection != [0, 0, 0, 0, 0, 0] and (tileData.river_connection.count(1) != 1):
					print("Drawing river at:", Vector2i(x, y), " with connection:", tileData.river_connection)
					riverTileSet[",".join(tileData.river_connection)]
					displayTilemap.set_cell(1, riverTileSet[",".join(tileData.river_connection)], 3, Vector2i(x, y))
	print("Map drawing complete.")

func generateRivers():
	print("Generating rivers...")
	var rng = RandomNumberGenerator.new()
	for start in range(riverStarters):
		randomize()
		rng.randomize()
		var random_binary = randi() % 4
		var x
		var y
		var direction
		match random_binary:
			0:
				direction = [0, 0, 1, 0, 0, 0]
				x = -size.x/2 + 1
				y = rng.randf_range(-size.y/2, size.y/2)
			1: 
				direction = [0, 0, 0, 0, 1, 0]
				y = -size.y/2 + 1
				x = rng.randf_range(-size.x/2, size.x/2)
			2:	
				direction = [0, 0, 0, 0, 0, 1]
				x = size.x/2 - 1
				y = rng.randf_range(-size.y/2, size.y/2)
			3:	
				direction = [0, 1, 0, 0, 0, 0]
				y = size.y/2 -1
				x = rng.randf_range(-size.x/2, size.x/2)
		print("River starting at:", Vector2i(x, y), " with direction:", direction)
		var tileData = tiles[Vector2i(x,y)]
		tileData.river_connection = direction

		var neighbor = neighborFinder(x, y, ",".join(direction))
		if y < 50 and x < 50 and x > -50 and y > -50:
			riverDirector(x + neighbor.x, y + neighbor.y, direction)
	print("River generation complete.")
func neighborFinder(x, y, direction):
	print("Finding neighbor for:", Vector2i(x, y), "with direction:", direction)
	
	var directions = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # move down (South)
		"0,1,0,0,0,0": Vector2i(0, -1), # move up (North)
		"0,0,1,0,0,0": Vector2i(1, 0),  # move right (East)
		"0,0,0,0,0,1": Vector2i(-1, 0), # move left (West)
		"0,0,0,1,0,0": Vector2i(1, 1),  # move down-right (Southeast)
		"1,0,0,0,0,0": Vector2i(-1, -1)  # move up-left (Northwest)
	}

	var move = directions.get(direction, Vector2i(0, 0))  # default move is no movement
	var neighbor_position = Vector2i(x, y) + move
	
	# Ensure the neighbor is within bounds of the map
	if neighbor_position.x < -size.x / 2 or neighbor_position.x >= size.x / 2 or neighbor_position.y < -size.y / 2 or neighbor_position.y >= size.y / 2:
		print("Neighbor out of bounds:", neighbor_position)
		return Vector2i(x, y)  # return the same position if out of bounds
	
	return neighbor_position

func riverDirector(x,y, direction):
	print("Directing river from:", Vector2i(x, y), " with direction:", direction)
	if !(Vector2i(x,y ) in tiles):
		print("No tile at:", Vector2i(x, y), "Skipping.")
		return
	var tileData = tiles[Vector2i(x, y)]
	var sides = direction.duplicate()
	var len = direction.size() # Copy the array to avoid modifying the original
	var n = 2
	# Ensure n is within bounds (wrap it around if n is larger than the array size)
	n = n % len
	for i in range(len):
		sides[i] = direction[(i + n) % len]
	var indexes = []
	for i in range(sides.size()):
		if sides[i] == 1:
			indexes.append(i)
	var before
	var after
	var occupied =[]
	for index in indexes:
		if index - 1 == 0:
			before = "top"
		elif index -1 ==1:
			before = "right"
		elif index -1 == 2:
			before = "bottom"
		elif index -1 == 3:
			before = "left"
		occupied.append(before) 
	print("Occupied sides:", occupied)
	return



