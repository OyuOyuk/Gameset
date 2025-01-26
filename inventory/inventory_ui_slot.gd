extends Panel

@onready var item_visual : Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text : Label = $CenterContainer/Panel/Label
var draggable = true
var slot_data = {}
var slot_index = -1
@export var inventory : Inventory

func set_index(index: int):
	slot_index = index
func update(slot: inventory_slot):
	slot_data = {"item" : slot.item, "amount" : slot.amount}
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		else:
			amount_text.visible = false
		
		amount_text.text = str(slot.amount)

#func _get_drag_data(at_position):
	#
	#var data = slot_data
	#var drag_texture = TextureRect.new()
	#drag_texture.expand_mode = true
	#drag_texture.texture = item_visual.texture
	#drag_texture.size = Vector2(48, 48)
	#var control = Control.new()
	#control.add_child(drag_texture)
	#drag_texture.position = -0.5 * drag_texture.size
	#set_drag_preview(control)
	#inventory.remove(data["item"], int(data["amount"]))
	#return data
#func _can_drop_data(at_position, data):
	#var current_slot = inventory.get_item_at_index(slot_index)
	#if  current_slot == null:
		#return true
	#elif current_slot.item == data["item"]:
		#return true
	#else:
		#return false
#
	#
#func _drop_data(at_position, data):
	#var current_slot = inventory.get_item_at_index(slot_index)
	#if current_slot == null:
		#inventory.insert(data["item"], data["amount"], slot_index)
		#item_visual.texture = data["item"].texture
		#amount_text.text = str(data["amount"])
		#item_visual.visible = true
	#else:
		#inventory.insert(data["item"], data["amount"], slot_index)
		#item_visual.texture = data["item"].texture
		#amount_text.text = str(current_slot.amount)


func _on_gui_input(event):
	if Input.is_action_just_pressed("Right_Click") and draggable == true:
		if slot_data["amount"] > 1:
			ConnectionManager.emit_signal("right_click_split", slot_index)
		else:
			ConnectionManager.emit_signal("left_click_drag", slot_index)
	elif Input.is_action_just_pressed("Left_Click") and draggable == true:
		ConnectionManager.emit_signal("left_click_drag", slot_index)

