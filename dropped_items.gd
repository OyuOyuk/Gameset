extends Node2D

@onready var master_drop = load("res://inventory/item_drops/master_drop_table.tres")
@export var collectable_item : PackedScene
# Called when the node enters the scene tree for the first time.
var drops = []
var drop_dict = {}
var multiplier = 1
func _ready():
	for drop in master_drop.object_drops:
		drop_dict[drop.name] = drop.drops

	ConnectionManager.connect("direct_item_drops", drop_direct)
func drop_direct(item, amount, coord):
	# Instantiate the collectable item
	var collectable = collectable_item.instantiate()
	collectable.item = item
	collectable.amount = amount
	
	# Set the position to the player's current position
	#collectable.position = VariablesManager.player_position
	collectable.position =  coord
	# Calculate the direction to the mouse
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (mouse_position - collectable.position).normalized()
  # Apply a velocity in the direction of the mouse
	collectable.linear_velocity = direction * 20  # Adjust multiplier for speed
	collectable.grace_period = 2
	# Add the collectable to the scene
	add_child(collectable)

#func drop_broken(selected_tile, coord):
	#var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	#var object = tile.object.object_id
	#print(object)
	#if object in drop_dict:
		#drops = drop_dict[object]
		#print(drops)
	#elif object not in drop_dict and tile.object.plant != null:
		#drops = drop_dict["generic_plant"]
	#if tile.object.plant != null:
		#if tile.object.plant.growth_stage <= 3:
			#drops = drop_dict["generic_plant"]
	#if tile.object.tree != null :
		#
		#multiplier = VariablesManager.tree_growth_stage_multipier[tile.object.tree.growth_stage]
	#for item in drops:
		#if randf() <= item.item_chance:
			#var collectable = collectable_item.instantiate() 
			#var random_amount= randf_range(item.min_amount , item.max_amount )
			#random_amount = random_amount * multiplier
			#collectable.item = item.item
			#collectable.amount = random_amount
			#var drop_offset = Vector2(randf_range(-32, 32), randf_range(-32, 32))
			#
			#collectable.position = coord + drop_offset  # Slight random spread around coord
			#collectable.modulate.a = 0.0
			#add_child(collectable)
			#var mouse_position = get_viewport().get_mouse_position()
			#var direction = (mouse_position - collectable.position).normalized()
			#collectable.linear_velocity = direction * 10  # Adjust multiplier for speed
			#collectable.grace_period = 2
			#var tween = create_tween()
			#tween.tween_property(collectable, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			#
