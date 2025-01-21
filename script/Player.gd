extends CharacterBody2D
var speed = {
	"water":200,
	"land":400
}
@export var tilemap : TileMap
@onready var animationTree = get_node("AnimationTree")
@onready var animation = get_node("AnimationPlayer")
@export var inventory : Inventory
@export var hotbar : Inventory
var in_water = "land"
var last_direction = Vector2.ZERO

var movement = true
func _ready():
	#animation.play("idle_front")
	animationTree.active = true
func _process(delta):
	update_animation_parameters()
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
#
	## Play animations based on input direction
	#if input_direction != Vector2.ZERO:
		## Prioritize side-walking animations
		#if abs(input_direction.x) >= abs(input_direction.y):
			#if input_direction.x < 0 and animation.current_animation != "run_left":
				#animation.play("run_left")
			#elif input_direction.x > 0 and animation.current_animation != "run_right":
				#animation.play("run_right")
		#else:
			#if input_direction.y < 0 and animation.current_animation != "run_back":
				#animation.play("run_back")
			#elif input_direction.y > 0 and animation.current_animation != "run_front":
				#animation.play("run_front")
	#else:
		## If no movement, play idle animation based on last direction
		#if last_direction.x < 0 and animation.current_animation != "idle_left":
			#animation.play("idle_left")
		#elif last_direction.x > 0 and animation.current_animation != "idle_right":
			#animation.play("idle_right")
		#elif last_direction.y < 0 and animation.current_animation != "idle_back":
			#animation.play("idle_back")
		#elif last_direction.y > 0 and animation.current_animation != "idle_front":
			#animation.play("idle_front")

	# Set velocity based on input direction and speed
	velocity = input_direction * speed[in_water]

	# Move the character if there is input
	if input_direction != Vector2.ZERO and movement == true:
		move_and_slide()

func collect(item):
	inventory.insert(item)
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animationTree["parameters/conditions/idle"] = true
		animationTree["parameters/conditions/is_moving"] = false
	else:
		animationTree["parameters/conditions/idle"] = false
		animationTree["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("Left_Click"):
		animationTree["parameters/conditions/swing"] = true
	else:
		animationTree["parameters/conditions/swing"] = false
	animationTree["parameters/idle/blend_position"] = last_direction
	animationTree["parameters/run/blend_position"] = last_direction
	animationTree["parameters/swing/blend_position"] = last_direction
		
