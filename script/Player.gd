extends CharacterBody2D
@export var speed = 400
var movement = true
func get_input():
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up", "ui_down")
	velocity = input_direction * speed
func _physics_process(delta):
	get_input()
	if movement == true:
		move_and_slide()
