extends Node2D
var size = VariablesManager.worldSize
@export var temperature_noise_tex : NoiseTexture2D
@onready var noise = temperature_noise_tex.noise
# Called when the node enters the scene tree for the first time.
func _ready():
	temp_assigner()
func temp_assigner():
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			var random_seed = int(str(WorldManager.get_seed()).substr(0, 2)) 
			var chunk = WorldManager.get_chunk(Vector2i(x, y))
			var temp_noise = noise.get_noise_2d(x+random_seed, y-random_seed)
			var temperature = floor(lerp(-10, 40, (temp_noise + 1) / 2))
			chunk.temperature = temperature
