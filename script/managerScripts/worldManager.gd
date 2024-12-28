extends Node

var chunks = {}  # Centralized storage for world data
var tiles = {}
var current_chunk: Vector2i = Vector2i(0, 0)
func _ready():
	generate_chunk(Vector2i(0, 0))
	get_chunk(Vector2i(0,0)).biome = "FOREST"
func generate_chunk(chunk_pos):
	if not chunks.has(chunk_pos):
		var new_chunk = worldData.new()
		chunks[chunk_pos] = new_chunk
		return new_chunk
	return chunks[chunk_pos]
func get_current_chunk():
	return current_chunk
func get_chunk(chunk_pos):
	return chunks.get(chunk_pos, null)
func check_chunk(chunk_pos):
	if chunks.has(chunk_pos):
		return true
	else:
		return false
func generate_tile(tile_pos):
	if not tiles.has(tile_pos):
		var new_tile = chunkData.new()
		tiles[tile_pos] = new_tile
		return tiles
	return tiles[tile_pos]
func get_tile(tile_pos):
	return tiles.get(tile_pos, null)
func move_chunk(current_chunk : Vector2i, direction):
	var is_even_column = current_chunk.x % 2 == 0

	# Define neighbor offsets for even and odd columns
	var directions_even = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # Down
		"0,1,0,0,0,0": Vector2i(0, -1), # Up
		"0,0,1,0,0,0": Vector2i(1, 0),  # Right-Up
		"1,0,0,0,0,0": Vector2i(-1, 0), # Left-Up
		"0,0,0,1,0,0": Vector2i(1, 1),  # Right-Down
		"0,0,0,0,0,1": Vector2i(-1, 1)  # Left-Down
	}

	var directions_odd = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # Down
		"0,1,0,0,0,0": Vector2i(0, -1), # Up
		"0,0,1,0,0,0": Vector2i(1, -1), # Right-Up
		"1,0,0,0,0,0": Vector2i(-1, -1), # Left-Up
		"0,0,0,1,0,0": Vector2i(1, 0),  # Right-Down
		"0,0,0,0,0,1": Vector2i(-1, 0)  # Left-Down
	}

	# Select directions based on column parity
	var directions = directions_odd if is_even_column else directions_even

	# Return the new position
	return current_chunk + directions[",".join(direction)]

