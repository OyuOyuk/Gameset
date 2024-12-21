extends CharacterBody2D
@export var speed = 400
func get_input():
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	if Input.is_action_just_pressed("Map"):
		get_tree().change_scene_to_file("res://map_trial.tscn")
	velocity = input_direction * speed
func _physics_process(delta):
	get_input()
	move_and_slide()
