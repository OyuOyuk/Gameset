extends Node

# Centralized storage
var chunks = {}  # Stores chunks using chunk positions as keys
var current_chunk: Vector2i = Vector2i(0, 0)
var user_seed
var clicked_pos = Vector2i(0,0)
var chunk_player_pos = Vector2i(0,0)
# Called when the node enters the scene
func _ready():
	# Example usage
	generate_chunk(Vector2i(0, 0))
	get_chunk(Vector2i(0, 0)).biome = "FOREST"
	ConnectionManager.user_seed.connect(seeder)
func seeder(seed):
	
	if seed.is_empty():
		randomize()
		user_seed = randi()
		
	else:
		user_seed = hash(seed)
	seed(user_seed)
	print(user_seed)
func get_seed():
	return user_seed

# Generate a new chunk at the specified position
func generate_chunk(chunk_pos: Vector2i) -> worldData:
	if not chunks.has(chunk_pos):
		var new_chunk = worldData.new()
		chunks[chunk_pos] = new_chunk
		return new_chunk
	return chunks[chunk_pos]

# Retrieve the current chunk position
func get_current_chunk() -> Vector2i:
	return current_chunk

# Retrieve a chunk by position
func get_chunk(chunk_pos: Vector2i) -> worldData:
	return chunks.get(chunk_pos, null)

# Check if a chunk exists at the given position
func check_chunk(chunk_pos: Vector2i) -> bool:
	return chunks.has(chunk_pos)

# Generate a new tile within a chunk
func generate_tile(chunk_pos: Vector2i, tile_pos: Vector2i) -> chunkData:
	var chunk = get_chunk(chunk_pos)
	if chunk:
		if not chunk.tiles.has(tile_pos):
			var new_tile = chunkData.new()
			chunk.tiles[tile_pos] = new_tile
			return new_tile
		return chunk.tiles[tile_pos]
	return null

# Retrieve a tile from a chunk
func get_tile(chunk_pos: Vector2i, tile_pos: Vector2i) -> chunkData:
	var chunk = get_chunk(chunk_pos)
	if chunk:
		return chunk.tiles.get(tile_pos, null)
	return null
