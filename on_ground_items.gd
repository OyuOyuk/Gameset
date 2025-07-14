extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.connect("ground_item_spawn", spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn(item_coord):
	pass
