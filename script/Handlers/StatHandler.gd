extends Node2D

var hunger_decrease_rate = -0.01  # Per second
var thirst_decrease_rate = -0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	StatsManager.update_hunger(hunger_decrease_rate * delta)
	
