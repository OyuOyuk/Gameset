extends Control
@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")

@onready var hotbar_slots : Array = $NinePatchRect/GridContainer.get_children()
var selected_slot : int = 0  # The currently selected hotbar slot (0–5)
var start_slot : int = 0  # The starting slot index to display (for scrolling)

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.update.connect(update_slots)
	ConnectionManager.connect("scroll_up", scroll_left)
	ConnectionManager.connect("scroll_down", scroll_right)
	for hotbar_slot in hotbar_slots:
		hotbar_slot.draggable = false
	update_slots()

func update_slots():
	# Ensure slots are not combined by correctly splitting them
	# Update hotbar slots (first 6 slots of the inventory)
	for i in range(6):
		if i < hotbar_slots.size():  # Ensure we only access valid slots
			hotbar_slots[i].modulate = Color(1, 1, 1)  # Reset to default color
	if selected_slot < hotbar_slots.size():
		hotbar_slots[selected_slot].modulate = Color(0.7, 0.7, 1)  # Slight blue tint to show selection
	for i in range(hotbar_slots.size()):
		if i < inventory.slots.size():
			hotbar_slots[i].update(inventory.slots[i])
		else:
			hotbar_slots[i].update(null) # Clear slot if no item exists

func use_selected_item():
	var item = inventory.slots[start_slot + selected_slot]
	if item:
		# Do something with the item, e.g., use it, equip it, etc.
		print("Using item: ", item.name)



func scroll_left():
	if selected_slot > 0:
		selected_slot -= 1
		WorldManager.selected_slot = selected_slot
		update_slots()
	else:
		selected_slot = 5
		WorldManager.selected_slot = selected_slot
		update_slots()

# Handle scrolling right (to go through inventory)
func scroll_right():
	if selected_slot < hotbar_slots.size() - 1:
		selected_slot += 1
		WorldManager.selected_slot = selected_slot
		update_slots()
	else:
		selected_slot = 0
		WorldManager.selected_slot = selected_slot
		update_slots()
