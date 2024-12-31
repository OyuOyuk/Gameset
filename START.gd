extends Button
@onready var texts = get_node("seedText")

func _on_pressed():
	var seed = texts.get_text()
	print(seed)
	ConnectionManager.user_seed.emit(seed)
	get_tree().change_scene_to_file("res://Main.tscn")
