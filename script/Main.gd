extends Node2D

@onready var map_scene = get_node("map_trial")
@onready var main_menu_scene = get_node("MainMenuPrototype")
var current_screen = "main"

@onready var camera = get_node("Player/Camera2D")  
@onready var player = get_node("Player") 
@onready var world = get_node("world")
# Called when the node enters the scene tree for the first time.
func _ready():

	world.visible = true
	map_scene.visible = false
	main_menu_scene.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Menu"):
		
		if camera.screen == "menu":
			camera.screen = "main"
			player.movement = true
		else:
			main_menu_scene.position = player.position - get_viewport().get_visible_rect().size/2
			camera.screen = "menu"
			player.movement = false
		map_scene.visible = false
		main_menu_scene.visible = !main_menu_scene.visible
	if Input.is_action_just_pressed("Map"):
		if camera.screen == "map":
			camera.screen = "main"
			player.movement = true
			
			
		else:
			camera.screen = "map"
			player.movement = false
			
		world.visible = !world.visible
		main_menu_scene.visible = false
		map_scene.visible = !map_scene.visible
		
