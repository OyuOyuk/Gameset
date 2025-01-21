extends Control

@onready var health = $health
@onready var hunger = $hunger
@onready var thirst = $thirst

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.connect("health_change", _on_health_change)

# Map a value from [0, max_in] to [0, max_out]
func map_to_range(value: float, max_in: float, max_out: float) -> float:
	return (value / max_in) * max_out

# Update health sprite scale
func _on_health_change(given_health):
	var health_scale = map_to_range(given_health, 100.0, 0.8)
	health.scale = Vector2(0.343, health_scale)  # Adjust scale proportionally
