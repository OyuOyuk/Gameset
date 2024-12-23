extends Camera2D

var screen = "main"
var dragging = false
var mouse_start_pos 
var original_pos = position
var screen_start_position
func _ready():
	pass
func _input(event):
	if Input.is_action_just_pressed("Map"):
		position = original_pos
	elif Input.is_action_just_pressed("Menu"):
		position = original_pos
	elif screen == "map" and event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

