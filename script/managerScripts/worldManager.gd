extends Node

var tiles = {}  # Centralized storage for world data

func generate_chunk(chunk_pos):
	if not tiles.has(chunk_pos):
		var new_chunk = worldData.new()
		tiles[chunk_pos] = new_chunk
		return new_chunk
	return tiles[chunk_pos]

func get_chunk(chunk_pos):
	return tiles.get(chunk_pos, null)
func check_chunk(chunk_pos):
	if tiles.has(chunk_pos):
		return true
	else:
		return false
