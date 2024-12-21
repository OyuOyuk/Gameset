extends TileMap

# Custom data layers
var biome_data = []
var temperature_data = []
var explored_data = []
var map_width : int = 100  # Default map width
var map_height : int = 100  # Default map height

func _ready():
	initialize_data_layers()  # Initialize the data layers when the scene starts

# Initialize the data layers
func initialize_data_layers():
	biome_data = []
	temperature_data = []
	explored_data = []

	# Create 2D arrays with default values
	for y in range(map_height):
		biome_data.append([])
		temperature_data.append([])
		explored_data.append([])
		for x in range(map_width):
			biome_data[y].append("forest")  # Default biome
			temperature_data[y].append(15)  # Default temperature
			explored_data[y].append(false)  # Default explored status

# Set custom data for a tile
func set_tile_data(x: int, y: int, biome: String, temperature: int, explored: bool):
	if x >= 0 and x < map_width and y >= 0 and y < map_height:
		biome_data[y][x] = biome
		temperature_data[y][x] = temperature
		explored_data[y][x] = explored

# Get custom data for a tile
func get_tile_data(x: int, y: int) -> Dictionary:
	if x >= 0 and x < map_width and y >= 0 and y < map_height:
		return {
			"biome": biome_data[y][x],
			"temperature": temperature_data[y][x],
			"explored": explored_data[y][x]
		}
	return {}  # Return empty dictionary if out of bounds

# Use custom data when placing a tile
func place_tile(x: int, y: int, tile_id: int, biome: String, temperature: int, explored: bool):
	# Hexagonal coordinates still use (x, y)
	set_cell(tile_id, Vector2i(x, y))  # Place the tile at the correct position
	set_tile_data(x, y, biome, temperature, explored)  # Set custom data

