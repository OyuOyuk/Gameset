extends Control
@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")

@onready var hotbar_slots : Array = $NinePatchRect/GridContainer.get_children()

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.update.connect(update_slots)
	update_slots()

func update_slots():
	# Ensure slots are not combined by correctly splitting them
	# Update hotbar slots (first 6 slots of the inventory)
	for i in range(hotbar_slots.size()):
		if i < inventory.slots.size():
			hotbar_slots[i].update(inventory.slots[i])
		else:
			hotbar_slots[i].update(null) # Clear slot if no item exists



func _process(delta):
	pass

