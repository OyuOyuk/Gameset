extends Control
@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var inventory_slots : Array = $TextureRect/GridContainer.get_children()
@onready var hotbar_slots : Array = $TextureRect/HotbarGridContainer.get_children()
@onready var held_item = $held
@onready var inventory_rect = get_node("inventory_rect")
var held_item_data = {

}
var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	held_item.get_node("amount").visible = false
	held_item_data["item"] = null
	held_item_data["amount"] = null
	inventory.update.connect(update_slots)
	ConnectionManager.connect("right_click_split", split )
	ConnectionManager.connect("left_click_drag", drag)
	 # Connect signals for hotbar slots
	held_item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_slots()
	close()

func mouse_in_inventory():
	# Replace `inventory_rect` with your inventory UI's Rect2
	var mouse_position = get_viewport().get_mouse_position()
	var rect = inventory_rect.get_global_rect()

	return not rect.has_point(mouse_position)
func split(slot_index):
	if held_item_data["item"] == null and is_open == true and  inventory.slots[slot_index].item != null:
		var taken_item =floor(inventory.slots[slot_index].amount / 2)
		held_item_data["item"] = inventory.slots[slot_index].item
		held_item_data["amount"] = taken_item
		held_item.get_node("item_display").texture =  inventory.slots[slot_index].item.texture
		held_item.get_node("amount").text = str(taken_item)
		inventory.slots[slot_index].amount = inventory.slots[slot_index].amount - taken_item
		if held_item_data["amount"] == 1:
			held_item.get_node("amount").visible = false
		else:
			held_item.get_node("amount").visible = true
	else:
		if( inventory.slots[slot_index].item == null or inventory.slots[slot_index].item ==  held_item_data["item"])and held_item_data["item"] != null:
			var given_item = floor(held_item_data["amount"] / 2 )
			inventory.slots[slot_index].item = held_item_data["item"]
			inventory.slots[slot_index].amount = inventory.slots[slot_index].amount + given_item
			held_item_data["amount"] = held_item_data["amount"] - given_item 
			held_item.get_node("amount").text = str( held_item_data["amount"])
	inventory.update_everything()
func drag(slot_index):
	if held_item_data["item"] == null and is_open == true and inventory.slots[slot_index].item != null:
		

		held_item_data["item"] = inventory.slots[slot_index].item
		held_item_data["amount"] = inventory.slots[slot_index].amount
		held_item.get_node("item_display").texture  =  inventory.slots[slot_index].item.texture
		held_item.get_node("amount").text = str(inventory.slots[slot_index].amount)
		inventory.slots[slot_index].item = null
		inventory.slots[slot_index].amount = 0
		
		if held_item_data["amount"] == 1:
			held_item.get_node("amount").visible = false
		else:
			held_item.get_node("amount").visible = true
	else:
		
		if 	(inventory.slots[slot_index].item == null or inventory.slots[slot_index].item ==  held_item_data["item"]) and held_item_data["item"] != null:
			
			inventory.slots[slot_index].item = held_item_data["item"]
			inventory.slots[slot_index].amount = inventory.slots[slot_index].amount + held_item_data["amount"] 
			held_item_data["item"] = null
			held_item_data["amount"] = 0 
			held_item.get_node("item_display").texture = null
			held_item.get_node("amount").visible = false
			held_item.get_node("amount").text = str(0)
	inventory.update_everything()
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
	
func _input(event):
	if Input.is_action_just_pressed("Right_Click") and mouse_in_inventory():
		if held_item_data["item"] != null:
			ConnectionManager.emit_signal("direct_item_drops", held_item_data["item"], floor(held_item_data["amount"]/2))
			var given_item = floor(held_item_data["amount"] / 2 )
			held_item_data["amount"] = held_item_data["amount"] - given_item 
			held_item.get_node("amount").text = str( held_item_data["amount"])
	if Input.is_action_just_pressed("Left_Click") and  mouse_in_inventory():
		if held_item_data["item"] != null:
			
			ConnectionManager.emit_signal("direct_item_drops", held_item_data["item"], held_item_data["amount"])
			held_item_data["item"] = null
			held_item_data["amount"] = 0 
			held_item.get_node("item_display").texture = null
			held_item.get_node("amount").visible = false
			held_item.get_node("amount").text = str(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
			if  held_item_data["item"] != null:
				pass
		else :
			open()
	held_item.position = get_local_mouse_position() - Vector2(16,16)
	mouse_in_inventory()
