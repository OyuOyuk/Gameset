extends RigidBody2D

@export var item : Inventory_Item
@export var amount : int
@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var player = null
var interactable = false
var grace_period =  0.5 # Adjust as needed

func _ready():
	sprite.texture = item.texture
	collision_shape.disabled = true  # Disable collision during grace period

func _process(delta):
	if grace_period > 0:
		grace_period -= delta
		collision_shape.disabled = true  # Disable collision during grace period
		interactable = false
	else:
		collision_shape.disabled = false  # Enable collision
		interactable = true
		linear_velocity = Vector2.ZERO

	# Only collect if within range and interactable
	if interactable and can_be_collected():
		linear_velocity = Vector2.ZERO
		if player and player.has_method("collect"):
			player.collect(item, amount)
			interactable = false
			queue_free()

func can_be_collected():
	if player:
		var distance = position.distance_to(player.global_position)
		return distance <= 32  # Adjust distance threshold as needed
	return false

func _on_interactable_area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		print("Player in range")

func _on_interactable_area_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		print("Player out of range")

