extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
func _process(delta):
	position = get_global_mouse_position()
