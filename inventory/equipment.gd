extends Control
@onready var equipment_inventory : Equipment_Inventory = preload("res://inventory/player_equipments.tres")
var equipment_slots = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		equipment_slots.append(child)
	ConnectionManager.connect("update_equipment_slots", update) 
func update():
	
	for equipment_slot in equipment_slots:
		if equipment_slot.has_method("update_slot") and equipment_slot.slot_type != null:
			var item = equipment_inventory.get(equipment_slot.slot_type)
			
			equipment_slot.update_slot(item)


func _on_head_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "head")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "head")


func _on_body_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "body")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "body")


func _on_hands_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "hands")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "hands")


func _on_legs_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "legs")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "legs")

func _on_feet_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "feet")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "feet")


func _on_accessory_gui_input(event):
	if Input.is_action_just_pressed("Right_Click"):
		ConnectionManager.emit_signal("right_equipment", "accessory")
	elif Input.is_action_just_pressed("Left_Click"):
		ConnectionManager.emit_signal("left_equipment", "accessory")
