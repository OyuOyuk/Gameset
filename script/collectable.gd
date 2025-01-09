extends StaticBody2D

@export var item : Inventory_Item
@onready var sprite : Sprite2D = $Sprite2D
var player = null
var interactable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = item.texture
func _on_interactable_area_body_entered(body):
	if body.is_in_group("Player"):
		interactable = true
		print("enter")
		player = body
			

func _on_interactable_area_body_exited(body):
	if body.is_in_group("Player"):
		interactable = false
		print("leave")
		player = null
func _input(event):
	if Input.is_action_just_pressed("interact") and interactable == true:
		if player and player.has_method("collect"):
			player.collect(item)
			queue_free()
		
		

