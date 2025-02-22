extends Sprite2D
@export var player :Node2D
var is_shooting = false
var shrink_speed = 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.connect("camera_changer", change)
	ConnectionManager.connect("shoot_bow", shoot)
func shoot(pos, held_item):
	player.movement = true
	ConnectionManager.emit_signal("camera_changer", "normal")
func change(string):
	if string == "bow":
		is_shooting = false
		player.movement = false
		scale = Vector2(3, 3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func start():
	scale = Vector2(5, 5)
	
func _process(delta):
	if scale >Vector2(0.2, 0.2):
		scale = scale.lerp(Vector2(0.2, 0.2), delta * shrink_speed)
