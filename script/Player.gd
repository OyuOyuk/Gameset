extends CharacterBody2D
var speed = {
	"water":200,
	"land":400
}
@export var tilemap : TileMap
var in_water = "land"
var movement = true
func get_input():
	
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	velocity = input_direction * speed[in_water]
func _physics_process(delta):
	var tile_pos = tilemap.local_to_map(global_position)
	
	if tilemap.get_cell_atlas_coords(0, Vector2i(tile_pos.x, tile_pos.y)) == Vector2i(0,0):
		in_water = "water"
	else:
		in_water = "land"
	
	get_input()
	if movement == true:
		move_and_slide()
