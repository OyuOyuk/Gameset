extends Node2D

@onready var map_scene = get_node("map_trial")

var current_screen = "main"
@onready var camera = get_node("world/active/Player/Camera2D")  
@onready var player = get_node("world/active/Player") 
@onready var active = get_node("world/active")
@onready var world = get_node("world")
@onready var world_grid = get_node("map_trial/outline2/outline")
# Called when the node enters the scene tree for the first time.
func _ready():
	camera.position = Vector2i(0, 0)
	world.visible = true
	map_scene.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if Input.is_action_just_pressed("Map"):
		if camera.screen == "map":
			camera.screen = "main"
			player.movement = true
			world_grid.on_screen = false
			camera.position = Vector2i(0, 0)
		else:
			camera.position = Vector2i(WorldManager.chunk_player_pos) - Vector2i(player.position)
			camera.screen = "map"
			player.movement = false
			world_grid.on_screen = true
		world.visible = !world.visible
		active.visible =  !active.visible
		map_scene.visible = !map_scene.visible
	if Input.is_action_just_pressed("tester"):
		StatsManager.update_health(-5.0)
