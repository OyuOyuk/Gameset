extends Node

var day_state = "morning" 
var state_thresholds = {
	"morning": [0, 6],  # 0-6 AM
	"afternoon": [6, 12],  # 6-12 PM
	"evening": [12, 18],  # 12-6 PM
	"night": [18, 24],  # 6-0 AM
}

var new_state
var time_of_day = 0.0  # 0.0 = Dawn, 0.4 = Midday, 0.8 = sunset, 1.0 = Dusk
func _process(delta):
	time_of_day += delta  # Change the multiplier for speed of day/night
	if time_of_day >= 24:
		time_of_day = 0

	if time_of_day >= state_thresholds["morning"][0] and time_of_day < state_thresholds["morning"][1]:
		new_state = "morning"
	elif time_of_day >= state_thresholds["afternoon"][0] and time_of_day < state_thresholds["afternoon"][1]:
		new_state = "afternoon"
	elif time_of_day >= state_thresholds["evening"][0] and time_of_day < state_thresholds["evening"][1]:
		new_state = "evening"
	else:
		new_state = "night"
	if new_state != day_state:
		day_state = new_state
		ConnectionManager.time_of_day.emit(day_state)
		
