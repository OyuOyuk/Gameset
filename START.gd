extends Button
@onready var texts = get_node("seedText")

func _on_pressed():
	var seeds = texts.get_text()
	print(seeds)
	ConnectionManager.user_seed.emit(seeds)
	get_tree().change_scene_to_file("res://Main.tscn")
