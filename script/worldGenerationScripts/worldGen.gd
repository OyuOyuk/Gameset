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
	"GRASSLANDS" : -0.2,
	"FOREST" : -0.2,
	"SAND" : -0.2
}
var values_water = {
	"GRASSLANDS" :-0.3,
	"FOREST" : -0.3,
	"SAND" : -0.3
}

@onready var script_a = $world
@onready var script_b = $water
func _ready():
	
	noise = LandNoise.noise
	water_noise = WaterNoise.noise
	var current_chunk = WorldManager.get_current_chunk()
	assignTiles(current_chunk)
	generateWorld(current_chunk)
	script_a._ready()
	script_b._ready()
func new_chunk(current_chunk):
	if WorldManager.get_tile(current_chunk, Vector2i(0, 0)) != null:
		assignTiles(current_chunk)
	generateWorld(current_chunk)
	script_a._ready()
	script_b._ready()
func waterGen():
	randomize()
	var radius = randi() % 30 + 20
	
	
		

func assignTiles(current_chunk):
	var min = - size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(min, -min):

			var terrain_noise_val = noise.get_noise_2d(x, y)
			var water_noise_val = water_noise.get_noise_2d(x, y)
			WorldManager.generate_tile(current_chunk,Vector2i(x,y))
			var noise_param 
			if terrain_noise_val >= values[WorldManager.get_chunk(current_chunk).biome]:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType = type.GRASS
			else:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType = type.DIRT

			if water_noise_val >=values_water[WorldManager.get_chunk(current_chunk).biome]:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence = false
			elif water_noise_val < values_water[WorldManager.get_chunk(current_chunk).biome]:
				WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence = true
		if y > 0:
			min = min + 0.5
		else:
			min = min - 0.5
	

func generateWorld(current_chunk):
	var min = -size.x/2
	for y in range(-size.y/2, size.y/2):
		for x in range(min, -min):

			if WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType == type.GRASS :
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif WorldManager.get_tile(current_chunk,Vector2i(x,y)).tileType == type.DIRT:
				world.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			if WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence == true:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif WorldManager.get_tile(current_chunk,Vector2i(x,y)).waterPrescence == false:
				water.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
		if y > 0:
			min = min + 0.5
		else:
			min = min - 0.5
