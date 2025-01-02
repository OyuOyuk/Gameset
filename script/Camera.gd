extends Camera2D

var screen = "main"
var dragging = false
var mouse_start_pos 
var original_pos = position
var screen_start_position
var map_size
func _ready():
	pass
func _input(event):

	if Input.is_action_just_pressed("Menu") and screen == "map":
		position =  WorldManager.chunk_player_pos
	elif screen == "map" and event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			
			dragging = false
	elif event is InputEventMouseMotion and dragging:
	
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

