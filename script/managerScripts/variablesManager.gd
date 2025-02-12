extends Node
var chunkSize = Vector2i(50, 100)
var worldSize = Vector2i(100, 100)
var breakable = {
	"axe" : ["tree"]
}
var tool_material_damage = {
	"test" : 20
}
var tree_growth_stage_multipier= {
	1: 0.2,
	2 : 0.5,
	3 : 1
}
var player_position
var plant_types = ["berry_bush", "bush"]
var flower_types = ["tall_flower", "flower"]
var plant_coords = {
	"berry_bush" : 0,
	"bush" : 1,

}
var flower_coords = {
	"tall_flower" : 0,
	"flower" : 1,
}
var bloomable = {
	"tall_flower" : true,
	"flower" : true,
}
var fruitable = {
	"berry_bush" : true,
	"bush" : false,
}
var in_season = {
	"berry_bush" :["Spring", "Summer", "Autumn", "Winter"],
	"bush" :["Spring", "Summer", "Autumn", "Winter"],
	"tall_flower" : ["Spring", "Summer", "Autumn", "Winter"],
	"flower" : ["Spring", "Summer", "Autumn", "Winter"],
}
var growth_time = {
	"berry_bush" :1,
	"bush" :1,
	"tall_flower" :1,
	"flower" :1,
}
var spread_chance = {
	"berry_bush" :0.2,
	"bush" :0.1,
	"tall_flower" :0.2,
	"flower" :0.1,
}
var wither_time = {
	"berry_bush" : 2,
	"bush" : 2,
	"tall_flower" : 2,
	"flower" : 2,
}
var flower_tiles = {}
var plant_tiles = {}
