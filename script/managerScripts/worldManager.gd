extends Node

var chunks = {}  # Centralized storage for world data
var tiles = {}
var player_tile: Vector2i = Vector2i(0, 0)
func _ready():
	generate_chunk(Vector2i(0, 0))
	get_chunk(Vector2i(0,0)).biome = "FOREST"
func generate_chunk(chunk_pos):
	if not chunks.has(chunk_pos):
		var new_chunk = worldData.new()
		chunks[chunk_pos] = new_chunk
		return new_chunk
	return chunks[chunk_pos]
func get_player_chunk():
	return player_tile
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
