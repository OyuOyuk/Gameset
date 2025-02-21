extends Resource

class_name Equipment_Inventory

@export var head : Inventory_Item
@export var body : Inventory_Item
@export var legs : Inventory_Item
@export var hands : Inventory_Item
@export var feet : Inventory_Item
@export var accessory : Inventory_Item
# Called when the node enters the scene tree for the first time.
func update_everything():
	ConnectionManager.emit_signal("update_equipment_slots")
