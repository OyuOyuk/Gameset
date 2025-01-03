
extends TileMap

@export var displayTilemap : TileMap
@export var grassPlaceholderAtlasCoord : Vector2i
@export var dirtPlaceholderAtlasCoord : Vector2i

var size  = VariablesManager.chunkSize
const NEIGHBOURS = [
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(0, 0)
]

var neighboursToAtlasCoord : Dictionary = {
	# All corners
	[TileType.GRASS, TileType.GRASS, TileType.GRASS, TileType.GRASS] : Vector2i(2, 1),
	# Outer bottom-right corner
	[TileType.DIRT, TileType.DIRT, TileType.DIRT, TileType.GRASS] : Vector2i(1, 3),
	# Outer bottom-left corner
	[TileType.DIRT, TileType.DIRT, TileType.GRASS, TileType.DIRT] : Vector2i(0, 0),
	# Outer top-right corner
	[TileType.DIRT, TileType.GRASS, TileType.DIRT, TileType.DIRT] : Vector2i(0, 2),
	# Outer top-left corner
	[TileType.GRASS, TileType.DIRT, TileType.DIRT, TileType.DIRT] : Vector2i(3, 3),
	# Right edge
	[TileType.DIRT, TileType.GRASS, TileType.DIRT, TileType.GRASS] : Vector2i(1, 0),
	# Left edge
	[TileType.GRASS, TileType.DIRT, TileType.GRASS, TileType.DIRT] : Vector2i(3, 2),
	# Bottom edge
	[TileType.DIRT, TileType.DIRT, TileType.GRASS, TileType.GRASS] : Vector2i(3, 0),
	# Top edge
	[TileType.GRASS, TileType.GRASS, TileType.DIRT, TileType.DIRT] : Vector2i(1, 2),
	# Inner bottom-right corner
	[TileType.DIRT, TileType.GRASS, TileType.GRASS, TileType.GRASS] : Vector2i(1, 1),
	# Inner bottom-left corner
	[TileType.GRASS, TileType.DIRT, TileType.GRASS, TileType.GRASS] : Vector2i(2, 0),
	# Inner top-right corner
	[TileType.GRASS, TileType.GRASS, TileType.DIRT, TileType.GRASS] : Vector2i(2, 2),
	# Inner top-left corner
	[TileType.GRASS, TileType.GRASS, TileType.GRASS, TileType.DIRT] : Vector2i(3, 1),
	# Bottom-left top-right corners
	[TileType.DIRT, TileType.GRASS, TileType.GRASS, TileType.DIRT] : Vector2i(2, 3),
	# Top-left down-right corners
	[TileType.GRASS, TileType.DIRT, TileType.DIRT, TileType.GRASS] : Vector2i(0, 1),
	# No corners
	[TileType.DIRT, TileType.DIRT, TileType.DIRT, TileType.DIRT] : Vector2i(0, 3)
}

func _ready():


	for coord in get_used_cells(0):
		set_display_tile(coord)

func set_tile(coords : Vector2i, atlas_coords : Vector2i):
	set_cell(0, coords, 0, atlas_coords)
	set_display_tile(coords)

func set_display_tile(pos : Vector2i):

	var random_binary = randi() % 2
	# Loop through 4 display neighbours
	for i in range(NEIGHBOURS.size()):
		var new_pos = pos + NEIGHBOURS[i]
		displayTilemap.set_cell(0, new_pos, random_binary, calculate_display_tile(new_pos)) #this shit

func calculate_display_tile(coords: Vector2i) -> Vector2i:
	# Get 4 world tile neighbors
	var bot_right = get_world_tile(coords - NEIGHBOURS[0])
	var bot_left = get_world_tile(coords - NEIGHBOURS[1])
	var top_right = get_world_tile(coords - NEIGHBOURS[2])
	var top_left = get_world_tile(coords - NEIGHBOURS[3])

	# Debugging output
	var neighbour_array = [top_left, top_right, bot_left, bot_right]


	# Return tile (atlas coord) that fits the neighbour rules
	if neighboursToAtlasCoord.has(neighbour_array):
		return neighboursToAtlasCoord[neighbour_array]
	else:
		print_debug("Missing key for neighbours: ", neighbour_array)
		return  Vector2i(1, 0)  # Default fallback
func get_world_tile(coords : Vector2i) -> TileType:
	
	var atlas_coord = get_cell_atlas_coords(0, coords)

	if atlas_coord == grassPlaceholderAtlasCoord:
		return TileType.GRASS
	else:
		return TileType.DIRT

enum TileType {
	NONE,
	GRASS,
	DIRT
}
