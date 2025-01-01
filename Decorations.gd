extends Node2D
@export var tilemap : TileMap
var size = Vector2i(100, 100)
var deco = {
	0 : Vector2i(0,0),
	1 : Vector2i(1,0),
	2 : Vector2i(2,0),
	3 : Vector2i(3,0),
	4 : Vector2i(0,1),
	5 : Vector2i(1,1),
}
# Called when the node enters the scene tree for the first time.
func _ready():
	mapGeneration()


func mapGeneration():
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			var tile = WorldManager.get_chunk(Vector2i(x,y))

			var random_binary = randi() % 6
			if tile.biome == "FOREST" and random_binary == 0 and tile.river_connection == [0,0,0,0,0,0]:

				random_binary = randi() % 6
				tilemap.set_cell(2, Vector2i(x,y), 3, deco[random_binary])
			random_binary = randi() % 4
			if tile.lake == true and tile.river_connection == [0,0,0,0,0,0] and tile.biome != "WATER":
				tilemap.set_cell(2, Vector2i(x,y), 4, deco[random_binary])
			
