extends Node2D

func _ready():
	set_process_input(true) 
func _input(ev):
	if Input.is_action_just_pressed("Map"):
		get_tree().change_scene_to_file("res://Main.tscn")
