extends CharacterBody2D
var speed = {
	"water":200,
	"land":300
}
@export var tilemap : TileMap

@export var crosshair : Node2D
@onready var plant_tilemaps = get_tree().get_nodes_in_group("plant_tilemaps")
@onready var animationTree = get_node("AnimationTree")
@onready var animationPlayer = get_node("animationPlayer") # Renamed from 'animation' for clarity
@onready var state_machine = animationTree.get("parameters/playback")
@onready var tool_collision = get_node("skeleton/tool_collision")
@onready var interactionHandler = get_node("InteractionHandler")
@onready var equipped_tool = get_node("skeleton/equiped_item/equipped_tool")

@export var camera : Camera2D
@export var inventory : Inventory
var local_trees
var forageTilemaps = {

}
var selected_tile
var state = "land"
var swing_action_timer = 0 # Renamed 'timer' for clarity, specifically for swing action cooldown
var last_direction = Vector2.ZERO
# var locked_direction = Vector2.ZERO # Not currently used, can remove if not needed
var current_chunk = WorldManager.get_current_chunk()
# var mouse_lock = false # Not currently used, can remove if not needed
var movement = true
var current_animation_node_name = "idle" # To store current animation node name

func _ready():
	interactionHandler.inventory = inventory
	for plant_tilemap in plant_tilemaps:
		forageTilemaps[plant_tilemap.name] = plant_tilemap
	print(forageTilemaps)
	local_trees = forageTilemaps["trees"]
	animationTree.active = true
	crosshair.visible = false
	ConnectionManager.connect("new_chunk_entered", new_chunk_handler)
	ConnectionManager.connect("player_collect", collect)

var min_zoom = Vector2(0.5, 0.5)
var max_zoom = Vector2(2.5, 2.5)

func zoom_camera(target_zoom: Vector2):
	var new_zoom = camera.zoom * target_zoom
	new_zoom.x = clamp(new_zoom.x, min_zoom.x, max_zoom.x)
	new_zoom.y = clamp(new_zoom.y, min_zoom.y, max_zoom.y)

	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", new_zoom, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func new_chunk_handler(new_chunk):
	current_chunk = WorldManager.get_current_chunk()

func _process(delta):
	update_animation_parameters() # This now handles movement state and animation conditions

	VariablesManager.player_position = position
	current_animation_node_name = state_machine.get_current_node() # Update for other logic if needed

	# Removed the problematic block from here. It's now inside update_animation_parameters.

	if inventory.slots[WorldManager.selected_slot].item != null:
		if Input.is_action_pressed("Left_Click"): # Continuous check for tool use
			
			if inventory.slots[WorldManager.selected_slot].item.property is Tool_Properties:
				
				# swing_action_timer check prevents rapid re-use while key is held
				if selected_tile != null  and movement: # Ensure can't use tool if movement is locked by animation
					print(WorldManager.get_tile(current_chunk,selected_tile).object)

					interactionHandler.right_tool(selected_tile, inventory.slots[WorldManager.selected_slot].item, forageTilemaps)
					# The swing animation and its timer are set in update_animation_parameters
					# swing_action_timer = 0.7 # Cooldown for the *action*, set when animation triggers

		if Input.is_action_just_pressed("Left_Click"): # For one-time usable items
			if inventory.slots[WorldManager.selected_slot].item.property.usable == true:
				interactionHandler.use(inventory.slots[WorldManager.selected_slot].item, WorldManager.selected_slot)

	if Input.is_action_just_pressed("scroll_left"):
		if Input.is_action_pressed("alt"):
			zoom_camera(Vector2(1.1, 1.1))
		else:
			ConnectionManager.emit_signal("scroll_up")

	if Input.is_action_just_pressed("scroll_right"):
		if Input.is_action_pressed("alt"):
			zoom_camera(Vector2(0.9, 0.9))
		else:
			ConnectionManager.emit_signal("scroll_down")

	if Input.is_action_just_pressed("interact") and selected_tile != null and movement: # Check 'movement' to prevent interaction during another locked animation
		var tile_data = WorldManager.get_tile(current_chunk, selected_tile)
		if tile_data and tile_data.object and tile_data.object.interactable == true:
			# The actual interaction animation trigger is in update_animation_parameters
			# This block now mostly just calls the handler if interaction is possible.
			# The animation will trigger the actual interaction via a signal or method call if needed.
			if tile_data.object.plant.plant_type == "flower":
				interactionHandler.interact(selected_tile, forageTilemaps["flowers"])
			elif tile_data.object.plant.plant_type == "plants":
				interactionHandler.interact(selected_tile, forageTilemaps["plants"])
			else:
				interactionHandler.interact(selected_tile, forageTilemaps["trees"])


	var player_pos_on_tilemap = local_trees.local_to_map(local_trees.to_local(position))
	var area_top_left = player_pos_on_tilemap - Vector2i(2,2)
	var area_bottom_right = player_pos_on_tilemap + Vector2i(2,2)
	var mouse_position = get_global_mouse_position()
	var tiled_mouse_position = local_trees.local_to_map(local_trees.to_local(mouse_position))

	var mouse_tile = WorldManager.get_tile(current_chunk, tiled_mouse_position)
	if mouse_tile != null and mouse_tile.object != null:
		var can_select_tile = false
		if inventory.slots[WorldManager.selected_slot].item != null and inventory.slots[WorldManager.selected_slot].item.property is Tool_Properties:
			var tool_type = inventory.slots[WorldManager.selected_slot].item.property.tool_type
			var object_on_tile = mouse_tile.object
			equipped_tool.texture = inventory.slots[WorldManager.selected_slot].item.texture
			if tool_type in object_on_tile.broken_by:
				if is_within_bounds(tiled_mouse_position, area_top_left, area_bottom_right):
					can_select_tile = true
		
		if mouse_tile.object.interactable == true:
			if is_within_bounds(tiled_mouse_position, area_top_left, area_bottom_right):
				can_select_tile = true
		
		if can_select_tile:
			crosshair.position = local_trees.map_to_local(tiled_mouse_position)
			crosshair.visible = true
			selected_tile = tiled_mouse_position
		else:
			crosshair.visible = false
			selected_tile = null
	else:
		crosshair.visible = false
		selected_tile = null
	
	if swing_action_timer > 0:
		swing_action_timer -= delta
		if swing_action_timer < 0:
			swing_action_timer = 0


func is_within_bounds(pos: Vector2i, top_left: Vector2i, bottom_right: Vector2i) -> bool:
	return (top_left.x <= pos.x and pos.x <= bottom_right.x) and \
		   (top_left.y <= pos.y and pos.y <= bottom_right.y)
func _physics_process(_delta):
	var tile_pos = tilemap.local_to_map(global_position)
	if tilemap.get_cell_atlas_coords(0, Vector2i(tile_pos.x, tile_pos.y)) == Vector2i(0, 0):
		state = "water"
	else:
		state = "land"

	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# --- Direction and Animation Logic ---
	if input_direction != Vector2.ZERO:
		# THE KEY CHANGE IS HERE: A bias to prioritize horizontal animations.
		# This value makes the horizontal input "stronger" in the comparison.
		# A higher value means the side animations are prioritized more heavily.
		# 1.0 = no bias. 1.5 = strong bias. Try values between 1.1 and 2.0.
		const HORIZONTAL_BIAS = 1.4 

		var new_facing_direction = Vector2.ZERO
		
		# Compare the biased horizontal input against the vertical input.
		# By multiplying abs(x) by our bias, we make it "win" the comparison
		# even when the raw input is slightly more vertical. This prevents flicker.
		if abs(input_direction.x) * HORIZONTAL_BIAS >= abs(input_direction.y):
			# Input is primarily horizontal, so we face left or right.
			new_facing_direction = Vector2(sign(input_direction.x), 0)
		else:
			# Only if the input is decisively vertical do we face up or down.
			new_facing_direction = Vector2(0, sign(input_direction.y))

		# Update the direction the character is facing.
		if new_facing_direction != Vector2.ZERO:
			last_direction = new_facing_direction

	# --- Movement Logic ---
	if movement == true:
		velocity = input_direction * speed[state]
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
func collect(item, amount):
	inventory.insert(item, amount)

func update_animation_parameters():
	# Get current animation state from the machine
	var current_node = state_machine.get_current_node()

	# Part 1: Determine movement lock and reset conditions based on CURRENT animation state
	if current_node == "swing" or current_node == "interact":
		movement = false # Lock movement if in an action animation
	else:
		movement = true  # Allow movement if not in an action animation
		# Reset one-shot animation conditions now that we are NOT in those states
		animationTree["parameters/conditions/swing"] = false
		animationTree["parameters/conditions/interact"] = false
		# swing_action_timer is handled in _process for its cooldown logic based on delta

	# Part 2: Set conditions for NEXT animation state based on input
	# These conditions will be processed by the AnimationTree. The 'current_node' will reflect the change on the next frame.
	
	# Handle Idle/Run conditions
	if velocity == Vector2.ZERO: # Use actual velocity
		animationTree["parameters/conditions/idle"] = true
		animationTree["parameters/conditions/is_moving"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_moving"] = true

	# Handle Swing Action
	# Prevent starting a new action if already in one (unless it's a combo or re-trigger)
	var can_start_action = (current_node != "swing" and current_node != "interact")

	if Input.is_action_pressed("Left_Click") and inventory.slots[WorldManager.selected_slot].item != null and can_start_action:
		if inventory.slots[WorldManager.selected_slot].item.property is Tool_Properties:
			if selected_tile != null: # Ensure a tile is selected for tool swing
				animationTree["parameters/conditions/swing"] = true
				# movement = false; // This is now handled by the check at the start of this function
				if swing_action_timer == 0: # Only set cooldown if it's not already active
					swing_action_timer = 0.7 # Cooldown for the tool ACTION itself (e.g., how often right_tool can be called)
	
	# Handle Interact Action
	if Input.is_action_just_pressed("interact") and selected_tile != null and can_start_action:
		var tile_data = WorldManager.get_tile(current_chunk, selected_tile)
		if tile_data and tile_data.object and tile_data.object.interactable == true:
			animationTree["parameters/conditions/interact"] = true
			# movement = false; // This is now handled by the check at the start of this function

	# Update blendspace positions (these should use the 'last_direction' which is updated in _physics_process)
	animationTree["parameters/idle/blend_position"] = last_direction
	animationTree["parameters/run/blend_position"] = last_direction
	animationTree["parameters/interact/blend_position"] = last_direction # Use last_direction for facing during animation
	animationTree["parameters/swing/blend_position"] = last_direction   # Use last_direction for facing during animation
