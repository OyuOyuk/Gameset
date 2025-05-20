extends Node2D

var hunger_decrease_rate = -0.01  # Per second
var thirst_decrease_rate = -0.1

var health = 100.0
var hunger = 100.0
var thirst = 100.0
var max_health: float = 100.0
var max_hunger: float = 100.0
var max_thirst: float = 100.0

var status_effects = []
@export var unlocked_recipes : recipe_table
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
func unlock_recipe(recipe  : item_recipe):
	unlocked_recipes.recipes.append(recipe)

func _process(delta):
	update_hunger(hunger_decrease_rate * delta)
	
