extends Node2D
@export var biomes_noise : NoiseTexture2D
@export var temperatures_noise : NoiseTexture2D
var save_path = ""
var data_stored = false
var biome_noise : Noise
var temperature_noise : Noise
var width : int = 100
var height : int = 100
@export var tilemap : TileMap 
@export var script_a : Node
@export var data: Node 
var biome_options = ["grassLands", "forests", "desert"]
func _ready():
	if data_stored == false:
		biome_noise = biomes_noise.noise
		generate_biomes()
		temperature_noise = temperatures_noise.noise
		generate_temperature()
	script_a._ready()


	
func generate_biomes():
	for x in range(width):
		for y in range(height):
			var noise_val = biome_noise.get_noise_2d(x,y)
			if noise_val >=0.3:
				data.biomes = Vector2i(1,0)
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(1, 0))
			elif noise_val < 0.3 :
				data.biomes = Vector2i(0,0)
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
			elif noise_val <-0.3:
				data.biomes = Vector2i(2,0)
				tilemap.set_cell(0,Vector2i(x,y), 0, Vector2i(0, 0))
func generate_temperature():
	for x in range(width):
		for y in range(height):
			var noise_val = temperature_noise.get_noise_2d(x,y)
			if noise_val >= -0.2:
				pass
			elif noise_val < -0.2:
				pass
