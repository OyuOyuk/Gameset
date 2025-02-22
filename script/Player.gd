extends CharacterBody2D
var speed = {
	"water":200,
	"land":300
}
@export var tilemap : TileMap

@export var crosshair : Node2D
@onready var plant_tilemaps = get_tree().get_nodes_in_group("plant_tilemaps")
@onready var animationTree = get_node("AnimationTree")
@onready var animation = get_node("animationPlayer")
@onready var state_machine =animationTree.get("parameters/playback")
@onready var tool_collision = get_node("skeleton/tool_collision")
@onready var interactionHandler = get_node("InteractionHandler")
@onready var equipped_tool = get_node("skeleton/equiped_item/equipped_tool")
@export var inventory : Inventory
var local_trees 
var forageTilemaps = {
	
}
var selected_tile
var state = "land"
var timer = 0
var last_direction = Vector2.ZERO
var locked_direction = Vector2.ZERO
var current_chunk = WorldManager.get_current_chunk()
var mouse_lock = false
var movement = true
var animationstate = "idle"
func _ready():
	#animation.play("idle_front")
	interactionHandler.inventory = inventory
	for plant_tilemap in plant_tilemaps:
		forageTilemaps[plant_tilemap.name] = plant_tilemap
	print(forageTilemaps)
	local_trees = forageTilemaps["trees"]
	animationTree.active = true
	crosshair.visible = false
	ConnectionManager.connect("new_chunk_entered", new_chunk_handler)
	ConnectionManager.connect("player_collect", collect)
	
	#for pos in touched_tiles:
		#print("Tile at ", pos, " is ", touched_tiles[pos])
func new_chunk_handler(new_chunk):
	current_chunk = WorldManager.get_current_chunk()
func _process(delta):
	update_animation_parameters()

	VariablesManager.player_position = position

	animationstate = state_machine.get_current_node()

	if state_machine.get_current_node() != "swing":
		#mouse_lock = false
		movement = true
		timer = 0
	if inventory.slots[WorldManager.selected_slot].item != null:

			
		
		if Input.is_action_pressed("Left_Click"):
			
			if inventory.slots[WorldManager.selected_slot].item.property is Tool_Properties:
				if selected_tile != null and timer == 0 :
					interactionHandler.right_tool(selected_tile,inventory.slots[WorldManager.selected_slot].item, forageTilemaps)
		if Input.is_action_just_pressed("Left_Click"):				

			if inventory.slots[WorldManager.selected_slot].item.property.usable == true:
				interactionHandler.use(inventory.slots[WorldManager.selected_slot].item, WorldManager.selected_slot)

				
					
	if Input.is_action_just_pressed("interact") and selected_tile != null :
		if WorldManager.get_tile(current_chunk, selected_tile).object.plant.plant_type == "flower":
			interactionHandler.interact(selected_tile, forageTilemaps["flowers"])
		else:
			interactionHandler.interact(selected_tile, forageTilemaps["trees"])
	var player_pos = local_trees.local_to_map(local_trees.to_local(position))

	var area_top_left = player_pos - Vector2i(2,2)  # Example start position
	var area_bottom_right = player_pos + Vector2i(2,2)    # Example end position
	var mouse_position = get_global_mouse_position()
	var tiled_mouse_position = local_trees.local_to_map(local_trees.to_local(mouse_position))
	
	var mouse_tile = WorldManager.get_tile(current_chunk, tiled_mouse_position)
	if mouse_tile != null:
		if mouse_tile.object != null:
			if inventory.slots[WorldManager.selected_slot].item != null and  inventory.slots[WorldManager.selected_slot].item.property is Tool_Properties:
				var tool_type = inventory.slots[WorldManager.selected_slot].item.property.tool_type
				var object = mouse_tile.object
				#var breakable = VariablesManager.breakable[tool_type]
				equipped_tool.texture = inventory.slots[WorldManager.selected_slot].item.texture
				if tool_type in object.broken_by:
					if is_within_bounds(tiled_mouse_position, area_top_left, area_bottom_right):
				
						
						crosshair.position =local_trees.map_to_local(tiled_mouse_position)
						crosshair.visible = true
						selected_tile = tiled_mouse_position
					else:
						crosshair.visible = false
						selected_tile = null
				
				else:
					crosshair.visible = false
					selected_tile = null
		
			if mouse_tile.object.interactable == true:

				if is_within_bounds(tiled_mouse_position, area_top_left, area_bottom_right):
				
						
					crosshair.position =local_trees.map_to_local(tiled_mouse_position)
					crosshair.visible = true
					selected_tile = tiled_mouse_position
				else:
					crosshair.visible = false
					selected_tile = null
			#else:
				#crosshair.visible = false
				#selected_tile = null
		else:
			crosshair.visible = false
			selected_tile = null

func is_within_bounds(pos: Vector2i, top_left: Vector2i, bottom_right: Vector2i) -> bool:
	return (top_left.x <= pos.x and pos.x <= bottom_right.x) and \
		   (top_left.y <= pos.y and pos.y <= bottom_right.y)

func _physics_process(_delta):
	var tile_pos = tilemap.local_to_map(global_position)

	# Determine if the player is in water or land
	if tilemap.get_cell_atlas_coords(0, Vector2i(tile_pos.x, tile_pos.y)) == Vector2i(0, 0):
		state = "water"
	else:
		state = "land"
	#if WorldManager.get_tile(WorldManager.get_current_chunk(),)
	# Get input direction

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Update last direction only when moving
	if input_direction != Vector2.ZERO and movement == true:
		
		last_direction = input_direction
		if abs(input_direction.x) == abs(input_direction.y):
			last_direction.x = 1 if last_direction.x > 0 else -1
			last_direction.y = 0

		#tool_collision.position = last_direction * 28


	# Set velocity based on input direction and speed
	velocity = input_direction * speed[state]
	
	# Move the character if there is input
	if input_direction != Vector2.ZERO and movement == true:
		move_and_slide()

#func _input(event):
	#if Input.is_action_pressed("Left_Click") and selected_tile != null and timer == 0 :
		#print("delete " , selected_tile)
		##interactionHandler.chop(selected_tile, forageTilemaps["trees"])
		#if inventory.slots[WorldManager.selected_slot].item != null:
			#if inventory.slots[WorldManager.selected_slot].item.property.type == 0:
				#interactionHandler.right_tool(selected_tile,inventory.slots[WorldManager.selected_slot].item, forageTilemaps["trees"])

func collect(item, amount):
	inventory.insert(item, amount)
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animationTree["parameters/conditions/idle"] = true
		animationTree["parameters/conditions/is_moving"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_moving"] = true
	if Input.is_action_pressed("Left_Click") and inventory.slots[WorldManager.selected_slot].item != null:
		if inventory.slots[WorldManager.selected_slot].item.property.type == 0:
			animationTree["parameters/conditions/swing"] = true
			timer = 0.7
			movement = false
		#mouse_lock = true
		#print(mouse_direction)
	else:
		animationTree["parameters/conditions/swing"] = false

	animationTree["parameters/idle/blend_position"] = last_direction
	animationTree["parameters/run/blend_position"] = last_direction
	animationTree["parameters/swing/blend_position"] = last_direction
