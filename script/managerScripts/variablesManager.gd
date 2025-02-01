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
var plant_coords = {
	"berry_bush" : 0,
	"bush" : 1,
}
