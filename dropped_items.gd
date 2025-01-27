extends Node2D

@onready var master_drop = preload("res://inventory/item_drops/master_drop_table.tres")
@export var collectable_item : PackedScene
# Called when the node enters the scene tree for the first time.
var drops = []
var drop_dict = {}
var multiplier = 1
func _ready():
	for drop in master_drop.object_drops:
		drop_dict[drop.name] = drop.drops
	ConnectionManager.connect("broken_object_drops", drop_broken)
	ConnectionManager.connect("direct_item_drops", drop_direct)
func drop_direct(item, amount, player_coord):
	pass
func drop_broken(selected_tile, coord):
	var tile = WorldManager.get_tile(WorldManager.get_current_chunk(), selected_tile)
	var object = tile.breakable_object
	drops = drop_dict[object]
	if tile.tree != null :
		
		multiplier = VariablesManager.tree_growth_stage_multipier[tile.tree.growth_stage]
	for item in drops:
		if randf() <= item.item_chance:
			var collectable = collectable_item.instantiate() 
			var random_amount= randf_range(item.min_amount , item.max_amount )
			random_amount = random_amount * multiplier
			collectable.item = item.item
			collectable.amount = random_amount
			var drop_offset = Vector2(randf_range(-64, 64), randf_range(-64, 64))
			
			collectable.position = coord + drop_offset  # Slight random spread around coord
			collectable.modulate.a = 0.0
			add_child(collectable)
			var tween = create_tween()
			tween.tween_property(collectable, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			
