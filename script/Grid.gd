extends TileMap

# Assuming each tile is a chunk, and the chunk size is 16x16 (or whatever your tile size is)
var on_screen = false
@onready var menu = get_node("mapPopup")
func _ready():
	menu.visible = false
func _input(event):
	if event is InputEventMouseButton and event.pressed and on_screen == true:	
		
		if  Input.is_action_just_pressed("Right_Click"):  # Left mouse button click
			var global_clicked  = get_local_mouse_position()
			var pos_clicked = local_to_map(to_local(global_clicked))
			menu.position = get_local_mouse_position()
			menu.visible = !menu.visible
			
			print(WorldManager.get_chunk(pos_clicked).biome)
			# Convert mouse position to tile position (world_to_map accounts for hex grid)
	
