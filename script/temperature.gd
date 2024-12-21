extends TileMap

# Custom data layers
var biome_data = []
var temperature_data = []
var explored_data = []

# This function will initialize the data layers
func initialize_data_layers():
	var width = get_used_rect().size.x
	var height = get_used_rect().size.y
	
	# Initialize the data arrays with default values
	biome_data = []  # Create a new empty array for biome data
	temperature_data = []  # Create a new empty array for temperature data
	explored_data = []  # Create a new empty array for explored status
	
	for i in range(height):
		biome_data.append([])  # Create a new row for biome data
		temperature_data.append([])  # Create a new row for temperature data
		explored_data.append([])  # Create a new row for explored status
	
	# Set default data values for each tile
	for x in range(width):
		for y in range(height):
			biome_data[y].append("forest")  # Default biome
			temperature_data[y].append("mild")  # Default temperature
			explored_data[y].append(false)  # Default explored status

# Function to set custom data for a tile
func set_tile_data(x: int, y: int, biome: String, temperature: String, explored: bool):
	biome_data[y][x] = biome
	temperature_data[y][x] = temperature
	explored_data[y][x] = explored

# Function to get custom data for a tile
func get_tile_data(x: int, y: int) -> Dictionary:
	return {
		"biome": biome_data[y][x],
		"temperature": temperature_data[y][x],
		"explored": explored_data[y][x]
	}

# Function to use custom data when placing a tile
func place_tile(x: int, y: int, tile_id: int, biome: String, temperature: String, explored: bool):
	set_cell(tile_id, Vector2i(x, y))  # Place the tile
	set_tile_data(x, y, biome, temperature, explored)  # Set the data layers for this tile
