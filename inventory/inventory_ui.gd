extends Control
@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var inventory_slots : Array = $TextureRect/GridContainer.get_children()
@onready var hotbar_slots : Array = $TextureRect/HotbarGridContainer.get_children()
@onready var held_item = $held_item
var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.update.connect(update_slots)
	 # Connect signals for hotbar slots

	update_slots()
	close()
func update_slots():
	# Ensure slots are not combined by correctly splitting them
	# Update hotbar slots (first 6 slots of the inventory)
	for i in range(hotbar_slots.size()):
		hotbar_slots[i].set_index(i)
		if i < inventory.slots.size():
			hotbar_slots[i].update(inventory.slots[i])
		else:
			hotbar_slots[i].update(null) # Clear slot if no item exists

	# Update inventory slots (remaining slots of the inventory)
	for i in range(inventory_slots.size()):
		var inventory_index = i + hotbar_slots.size()
		inventory_slots[i].set_index(inventory_index)
		if inventory_index < inventory.slots.size():
			inventory_slots[i].update(inventory.slots[inventory_index])
		else:
			inventory_slots[i].update(null) # Clear slot if no item exists

func close():
	visible = false
	is_open = false
func open():
	visible = true
	is_open = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else :
			open()

