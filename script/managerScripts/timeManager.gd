extends Node

# Time variables
var current_hour = 0
var current_minute = 0
var current_day = 1
var current_month = 1
var current_year = 1
var current_season = "Spring"  # Just an example, you'll probably want to change this dynamically

# Time progression settings
var real_seconds_per_in_game_minute = 1.0
var in_game_minutes_per_real_second = 1 / real_seconds_per_in_game_minute
var time_passed = 0.0

# Seasonal data (example)
var seasons = ["Spring", "Summer", "Autumn", "Winter"]
var days_in_season = 28  # Just an example, adjust for your game

# Singleton methods to access time globally
func _ready():
	# Called when the game starts
	pass

func _process(delta):
	# Update in-game time
	time_passed += delta * in_game_minutes_per_real_second
	if time_passed >= 1.0:
		advance_time(int(time_passed))
		time_passed = fmod(time_passed, 1.0)

func advance_time(minutes):
	current_minute += minutes
	if current_minute >= 60:
		current_hour += current_minute / 60
		current_minute %= 60
	if current_hour >= 24:
		current_day += current_hour / 24
		current_hour %= 24
		if current_day > days_in_season:
			current_month += 1
			current_day = 1
			if current_month > 12:
				current_year += 1
				current_month = 1
			update_season()

func update_season():
	var season_index = int((current_month - 1) / 3)  # Assuming 3 months per season
	current_season = seasons[season_index]

func get_time_string():
	return "%02d:%02d" % [current_hour, current_minute]

func get_date_string():
	return "day %d of %d, year %d" % [current_day, current_month, current_year]

func get_season():
	return current_season
