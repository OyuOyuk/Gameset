extends TileMap

# Assuming each tile is a chunk, and the chunk size is 16x16 (or whatever your tile size is)
var on_screen = false
@onready var menu = get_node("mapPopup")
@onready var player = get_node("player")
var pos : Vector2i

func _ready():
	player.position =  map_to_local(Vector2i(0, 0))
	menu.visible = false	
	add_to_group("map")
func _input(event):
	if event is InputEventMouseButton and event.pressed and on_screen == true:	
			
		if  Input.is_action_just_pressed("Right_Click"):  # Left mouse button click
			var global_clicked  = get_local_mouse_position()
			var pos_clicked = local_to_map(to_local(global_clicked))
			WorldManager.clicked_pos = pos_clicked
			pos = map_to_local(pos_clicked)
			menu.position = get_local_mouse_position()
			menu.visible = !menu.visible
			
			print(WorldManager.get_chunk(pos_clicked).biome)
			# Convert mouse position to tile position (world_to_map accounts for hex grid)

func yes():
	player.position =  map_to_local(WorldManager.clicked_pos)
	menu.visible = false

	
	#var global_clicked  = get_local_mouse_position()
	#var pos_clicked = local_to_map(to_local(global_clicked))
	WorldManager.current_chunk = WorldManager.clicked_pos
	print(WorldManager.clicked_pos)
	ConnectionManager.new_map_position.emit(WorldManager.clicked_pos)
