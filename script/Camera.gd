extends Camera2D

var screen = "main"
var dragging = false
var mouse_start_pos 
var original_pos = position
var screen_start_position
var map_size
@export var bow_cursor :Sprite2D
var camera_ver = "normal"
var dead_zone_size := Vector2(800, 400) 	
func _ready():
	ConnectionManager.connect("camera_changer", camera_changer)
	
func camera_changer(type):
	camera_ver =  type
func _process(delta):
	if camera_ver == "bow":
		bow_cursor.visible = true
		follow_cursor(delta)
	else:
		position = Vector2(0, -)
func _input(event):

	if screen == "map" and event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			
			dragging = false
	elif event is InputEventMouseMotion and dragging:
	
		position = zoom * (mouse_start_pos - event.position) + screen_start_position

func follow_cursor(delta):
	var mouse_position = get_global_mouse_position()#(0,-1)
	
	
	var to_mouse = mouse_position - global_position
	if abs(to_mouse.x) > dead_zone_size.x / 2 or abs(to_mouse.y) > dead_zone_size.y / 2:
		position  =  position.lerp(mouse_position, 1.0 * delta)
	bow_cursor.position = get_global_mouse_position()
