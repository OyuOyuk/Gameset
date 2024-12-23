extends Node
class_name saveLoader
@onready var player = get_tree().get_root().get_node("Main/Player")

func _on_save_pressed():
	var file = FileAccess.open("res://saves/savegame.data", FileAccess.WRITE)
	file.store_var(player.global_position)
	file.close


func _on_load_pressed():
	var file = FileAccess.open("res://saves/savegame.data", FileAccess.READ)
	player.global_position = file.get_var()
	file.close
