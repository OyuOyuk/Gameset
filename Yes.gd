extends Button


func _on_pressed():
	get_tree().call_group("map", "yes")
