extends CharacterBody2D
var speed = {
	"water":200,
	"land":400
}
@export var tilemap : TileMap
@onready var animation = get_node("AnimationPlayer")
@export var inventory : Inventory
@export var hotbar : Inventory
var in_water = "land"
var last_direction = Vector2.ZERO

var movement = true
func _ready():
	animation.play("idle_front")
func _physics_process(_delta):
	var tile_pos = tilemap.local_to_map(global_position)

	# Determine if the player is in water or land
	if tilemap.get_cell_atlas_coords(0, Vector2i(tile_pos.x, tile_pos.y)) == Vector2i(0, 0):
		in_water = "water"
	else:
		in_water = "land"
	#if WorldManager.get_tile(WorldManager.get_current_chunk(),)
	# Get input direction
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Update last direction only when moving
	if input_direction != Vector2.ZERO:
		last_direction = input_direction

	# Play animations based on input direction
	if input_direction != Vector2.ZERO:
		# Prioritize side-walking animations
		if abs(input_direction.x) >= abs(input_direction.y):
			if input_direction.x < 0 and animation.current_animation != "run_left":
				animation.play("run_left")
			elif input_direction.x > 0 and animation.current_animation != "run_right":
				animation.play("run_right")
		else:
			if input_direction.y < 0 and animation.current_animation != "run_back":
				animation.play("run_back")
			elif input_direction.y > 0 and animation.current_animation != "run_front":
				animation.play("run_front")
	else:
		# If no movement, play idle animation based on last direction
		if last_direction.x < 0 and animation.current_animation != "idle_left":
			animation.play("idle_left")
		elif last_direction.x > 0 and animation.current_animation != "idle_right":
			animation.play("idle_right")
		elif last_direction.y < 0 and animation.current_animation != "idle_back":
			animation.play("idle_back")
		elif last_direction.y > 0 and animation.current_animation != "idle_front":
			animation.play("idle_front")

	# Set velocity based on input direction and speed
	velocity = input_direction * speed[in_water]

	# Move the character if there is input
	if input_direction != Vector2.ZERO and movement == true:
		move_and_slide()

func collect(item):
	inventory.insert(item)

#func update_lower_body_animation():
	#var direction = Vector2.ZERO
	#direction.x = Input.get_axis("ui_left", "ui_right")
	#direction.y = Input.get_axis("ui_up", "ui_down")
	#
	## store the last direction
	#if direction != last_direction && Input.is_anything_pressed() != false:
		#last_direction = direction
		#
	## update direction and velocity
	#if direction.x != 0:
		#velocity.x = direction.x * speed
		#if direction.x < 0:
			#animation_player.play_backwards("walk_left")
			#
		#else:
			#animation_player.play("walk_right")
	#else: 
		#velocity.x = 0
		#
	#if direction.y != 0:
		#velocity.y = direction.y * speed
		#if velocity.y != velocity.x && -velocity.y != velocity.x:
			#if direction.y < 0:
				#animation_player.play("walk_up")
			#else:
				#animation_player.play("walk_down")
		#else:
			#if direction.x < 0:
				#animation_player.play_backwards("walk_left")
			#
			#else:
				#animation_player.play("walk_right")
		#
	#else: 
		##move_toward(velocity.y, 0, speed * delta)
		#velocity.y = 0
	##idle animation 
	#if direction == Vector2.ZERO:
		#if last_direction.x < 0:
			#animation_player.play("Idle_left")
		#if last_direction.x > 0:
			#animation_player.play("Idle_right")
		#if last_direction.y < 0:
			#animation_player.play("Idle_up")
		#if last_direction.y > 0:
			#animation_player.play("Idle_down")
		#
