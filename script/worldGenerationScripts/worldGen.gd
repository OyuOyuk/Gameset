extends Node2D

@export var LandNoise :NoiseTexture2D
@export var WaterNoise :NoiseTexture2D

@export var world : TileMap
@export var water : TileMap

enum type { GRASS, DIRT }

var noise : Noise
var water_noise : Noise
var size  = Vector2i(50,100)
var values = {
	"GRASSLANDS" : [0, 1],
}
var tiles ={
	
}
@onready var script_a = $world
@onready var script_b = $water
func _ready():
	
	noise = LandNoise.noise
	water_noise = WaterNoise.noise
	assignTiles()
	generateWorld()
	script_a._ready()
	script_b._ready()


func assignTiles():
	var min = - size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(min, -min):
		
			var tile = chunkData.new()
			tile.pos = Vector2i(x, y)
			var terrain_noise_val = noise.get_noise_2d(x, y)
			var water_noise_val = water_noise.get_noise_2d(x, y)

			if terrain_noise_val >=-0.1:
				tile.tileType = type.GRASS
			elif terrain_noise_val <-0.1:
				tile.tileType = type.DIRT

			if water_noise_val >= -0.2:
				tile.waterPrescence = false
			elif water_noise_val < -0.2:
				tile.waterPrescence = true
			tiles[Vector2i(x,y)] = tile
		if y > 0:
			min = min + 0.5
		else:
			min = min - 0.5
	

func generateWorld():
	var min = -size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(min, -min):
			var tileData = tiles[Vector2i(x,y)]
			
			if tileData.tileType == type.GRASS :
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif tileData.tileType == type.DIRT:
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			if tileData.waterPrescence == true:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif tileData.waterPrescence == false:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
		if y > 0:
			min = min + 0.5
		else:
			min = min - 0.5
