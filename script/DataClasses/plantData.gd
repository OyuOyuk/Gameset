extends Node
class_name PlantData
var plant_name = "default plant"
var plant_type = null
var sprite_variant = 0
var health = 100
var rot = 0
var days_elapsed = 0
var last_date_updated = 0
var plant_id = "default_plant_t1"
var atlas_coords = Vector2i(0,0)
var growth_stage = 3
var blossomable = false
var fruitable = false
var chopped = false
var turned_sprite = false
class TreeData extends PlantData:
	var root_atlas_coords = Vector2i(0,0)
