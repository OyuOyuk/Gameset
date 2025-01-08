extends Panel

@onready var item_visual : Sprite2D = $Sprite2D
@onready var amount_text : Label = $amount

var holdable = false

func update(slot: inventory_slot):
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
