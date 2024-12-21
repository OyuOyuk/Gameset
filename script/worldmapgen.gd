extends Node2D
@export var noise_height_texture : NoiseTexture2D
@export var temperature_noise_height_texture : NoiseTexture2D

var noise : Noise
var temp_noise : Noise
@onready var world = get_node("DataMap")
var width : int = 100
var height : int = 100


func _ready():
	
	noise = noise_height_texture.noise
	temp_noise = temperature_noise_height_texture.noise
	generate_world()



	
func generate_world():
	for x in range(width):
		for y in range(height):
			
			var noise_val = noise.get_noise_2d(x,y)
			var temp_noise_val = temp_noise.get_noise_2d(x,y)
			var temperature = noise_to_temperature(temp_noise_val)
			if noise_val >= 0.0:
				world.place_tile(x,y, 0, "Forest", temperature, false) # set as forest 
			elif noise_val <0.0:
				world.place_tile(x,y, 1, "Default", temperature, false) # set as default
func noise_to_temperature(noise_value: float) -> float:
	# Map noise value from [-0.5, 0.5] to [-10, 40]
	return -10 + ((noise_value + 0.5) * 50)
