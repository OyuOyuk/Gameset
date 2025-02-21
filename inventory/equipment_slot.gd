extends Panel

var draggable = true
var slot_data = {}
var slot_index = -1
@export var slot_type: String  # Example values: "head", "body", "legs", etc.
@onready var item_icon = $item_display  # Adjust to your actual node path

func update_slot(item: Inventory_Item):
	print("activated")
	if item != null:
		item_icon.texture = item.texture  # Assuming Inventory_Item has an `icon` property
		item_icon.visible = true
	else:
		item_icon.texture = null
		item_icon.visible = false
#func _on_gui_input(event):
	#if Input.is_action_just_pressed("Right_Click") and draggable == true:
		#if slot_data["amount"] > 1:
			#ConnectionManager.emit_signal("right_click_split", slot_index)
		#else:
			#ConnectionManager.emit_signal("left_click_drag", slot_index)
	#elif Input.is_action_just_pressed("Left_Click") and draggable == true:
		#ConnectionManager.emit_signal("left_click_drag", slot_index)
