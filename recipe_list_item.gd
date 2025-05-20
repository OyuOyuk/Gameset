extends Button


var associated_recipe_data

func _on_pressed():
	ConnectionManager.emit_signal("recipe_clicked", associated_recipe_data)

func set_recipe_info(data):
	associated_recipe_data = data
	text = data.output_item.name 
