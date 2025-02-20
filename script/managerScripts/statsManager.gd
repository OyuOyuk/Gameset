extends Node

var health = 100.0
var hunger = 100.0
var thirst = 100.0
var status_effects = []
# Called when the node enters the scene tree for the first time.
func update_health(amount: float):
	health += amount
	health = clamp(health, 0, 100)  # Clamp health between 0 and 100
	ConnectionManager.emit_signal("health_change", health)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_hunger(amount: float):
	hunger += amount
	hunger = clamp(hunger, 0, 100)  # Clamp health between 0 and 100 hunger_change
	ConnectionManager.emit_signal("hunger_change", hunger)
func add_status_effect(effect: String):
	status_effects.append(effect)
func remove_status_effect(effect: String):
	status_effects.erase(effect)
