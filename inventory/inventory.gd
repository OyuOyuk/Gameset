extends Resource

class_name Inventory
signal update

@export var slots: Array[inventory_slot]
func update_everything():
	emit_signal("update")
func search(item: Inventory_Item, amount: int):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	var amount_counted = 0
	for slot in item_slots:
		amount_counted = amount_counted + slot.amount
	if amount_counted >= amount:
		return true
	else:
		return false
# In Inventory.gd
func insert(item: Inventory_Item, amount: int = 1, target_slot_index: int = -1):
	if item == null or amount <= 0:
		return # Exit early if the item is null or the amount is invalid.
	
	# If a specific slot index is provided (not -1)
	if target_slot_index >= 0 and target_slot_index < slots.size():
		var slot = slots[target_slot_index]
		if slot.item == null:  # If the target slot is empty
			slot.item = item
			slot.amount = amount  # Set amount when first inserted
		elif slot.item == item and slot.item.property.stackable == true:  # If the target slot has the same item
			slot.amount += amount  # Increase the amount in the existing slot
		else:
			print("Target slot already contains a different item.")
			return
	else:
		# Check if the item already exists in the inventory
		var item_slots = slots.filter(func(slot): return slot.item == item)
		if item_slots.size() > 0 and item.property.stackable == true:  # If the item already exists in any slot
			item_slots[0].amount += amount  # Increase the amount in the first matching slot
		else:
			# Find an empty slot
			var empty_slots = slots.filter(func(slot): return slot.item == null)
			if empty_slots.size() > 0:
				empty_slots[0].item = item
				empty_slots[0].amount = amount  # Set the specified amount when first inserted
			else:
				# Inventory is full, handle this case
				print("Inventory is full! Cannot insert item.")
				return

	# Emit the update signal to notify the UI to refresh
	emit_signal("update")


func remove(item: Inventory_Item, amount_to_remove: int):
	if item == null:
		return # Exit early if the item is null (no item to remove).

	var item_slots = slots.filter(func(slot): return slot.item == item)
	if item_slots.size() > 0:
		var slot = item_slots[0]
		
		# Check if enough quantity exists to remove
		if slot.amount >= amount_to_remove:
			slot.amount -= amount_to_remove
			if slot.amount == 0:
				slot.item = null  # Clear item if amount is zero
		else:
			print("Not enough quantity to remove.")
			return
	else:
		print("Item not found in inventory.")
		return

	# Emit the update signal to notify the UI to refresh
	emit_signal("update")

func get_item_at_index(target_slot_index:int):
	var slot = slots[target_slot_index]
	if slot.item != null:
		return slot
	else:
		return null
