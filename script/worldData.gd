extends Node2D
class_name worldData

# World properties
var pos = []
var playerPos =  false                   # Position in the world
var exploration = false          # Whether the chunk is explored
var biome = "GRASSLANDS"        # Biome type
var temperature = 20             # Temperature of the chunk
var structures = []              # Structures in the chunk
var river_connection = [0, 0, 0, 0, 0, 0]  # River connections (hex grid: 6 sides)
var road_connection = [0, 0, 0, 0, 0, 0]   # Road connections (hex grid: 6 sides)
var river_size = 0
var lake = 0

