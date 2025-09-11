extends Node
var chunkSize = Vector2i(50, 100)
var worldSize = Vector2i(100, 100)
#var breakable = {
	#"axe" : ["tree", "bush", "berry_bush", "Ashen Lily"]
#}
var tool_material_damage = {
	"test" : 20,
	"stone" : 20,
}
var tree_growth_stage_multipier= {
	1: 0.2,
	2 : 0.5,
	3 : 1
}
var new_chunk_tree_life_cycle = 30
var player_position
var plant_types = ["berry_bush", "bush", "grass"]
var flower_types = ["Ashen Lily", "flower", "Ember Petals", "Pale WildFlowers"]
var tree_types = ["oak_tree","pine_tree"]
var plant_coords = {
	"berry_bush" : 0,
	"bush" : 1,
	"grass": 2,

}
var flower_coords = {
	"Ashen Lily" : 0,
	"flower" : 1,
	"Ember Petals" : 2,
	"Pale WildFlowers" : 3
}
var tree_coords = {
	"oak_tree" : [0, 1],
	"pine_tree" : [2, 3]
}
var bloomable = {
	"Ashen Lily" : true,
	"flower" : true,
	"Ember Petals" : true,
	"Pale WildFlowers" : true
}
var fruitable = {
	"berry_bush" : true,
	"bush" : false,
	"grass" : false,
}
var in_season = {
	"berry_bush" :["Spring", "Summer", "Autumn", "Winter"],
	"bush" :["Spring", "Summer", "Autumn", "Winter"],
	"Ashen Lily" : ["Spring", "Summer", "Autumn", "Winter"],
	"flower" : ["Spring", "Summer", "Autumn", "Winter"],
}
var growth_time = {
	"berry_bush" :1,
	"bush" :1,
	"grass":1,
	"Ashen Lily" :1,
	"flower" :1,
	"Ember Petals" : 1,
	"Pale WildFlowers" : 1,
	"oak_tree" : 1,
	"pine_tree" : 1
}
var spread_chance = {
	"berry_bush" :0.5,
	"bush" :0.5,
	"grass" :0.8,
	"Ashen Lily" :0.5,
	"flower" :0.5,
	"Ember Petals" : 0.5,
	"Pale WildFlowers" : 0.5,
	"oak_tree" : 0.5,
	"pine_tree" : 0.5,
}
var flower_circle_size = {
	"Ashen Lily" : [3, 4],
	"flower" : [4, 8],
	"Ember Petals" : [2, 4],
	"Pale WildFlowers" : [4, 12]
}
var wither_time = {
	"berry_bush" : 10,
	"bush" : 10,
	"grass":5,
	"Ashen Lily" : 10,
	"flower" : 10,
	"Ember Petals" : 10,
	"Pale WildFlowers" : 10,
	"oak_tree" : 18,
	"pine_tree" : 18,
}
var flower_tiles = {}
var plant_tiles = {}
var tree_tiles = {}
var forage_tiles = {}
var rule = {
	"road" : ["road", "house_plot", "park"],
	"house_plot": ["road"],
	"park" : ["park", "road"]
}	
var tree_amount = {
	"FOREST": 150,
	"GRASSLANDS":20,
	"SAND":0,
	"WATER":0, 
}
var grass_amount = {
	"FOREST": 400,
	"GRASSLANDS":500,
	"SAND":0,
	"WATER":0, 
}
var plant_amount = {
	"FOREST": 400,
	"GRASSLANDS":500,
	"SAND":0,
	"WATER":0, 
}
var values = {
	"GRASSLANDS" : -0.3,
	"FOREST" : -0.1,
	"SAND" : -0.2,
	"WATER" : -0.2
}
var onground_items = {
	"GRASSLANDS" : 10,
	"FOREST" : 100,
	"SAND" : 50,
	"WATER" : 0
}
var onground_possible_items = {
	"GRASSLANDS" : [],
	"FOREST" : [],
	"SAND" : [],
	"WATER" : []
}

