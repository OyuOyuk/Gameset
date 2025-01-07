extends Resource

class_name Inventory
signal update

@export var slots: Array[inventory_slot]

func insert(item: Inventory_Item):
	if item == null:
		return # Exit early if the item is empty.

	# Check if the item already exists in the inventory
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if item_slots.size() > 0:  # Check if the filtered array has elements
		item_slots[0].amount += 1
	else:
		# Find an empty slot
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if empty_slots.size() > 0:  # Check if there are empty slots
			empty_slots[0].item = item
			empty_slots[0].amount = 1
		else:
			# Inventory is full, handle this case
			print("Inventory is full! Cannot insert item.")
			return

	# Emit the update signal after modifying the inventory
	emit_signal("update")
