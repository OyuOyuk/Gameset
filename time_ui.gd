extends Control
@onready var minute_hand = $pocket_watch/minute
@onready var hour_hand = $pocket_watch/hour
@onready var date = $pocket_watch/date
func _process(delta):
	var hour_angle = (TimeManager.current_hour % 12) / 12.0 * 360
	var minute_angle = TimeManager.current_minute / 60.0 * 360
	hour_hand.rotation = deg_to_rad(hour_angle)
	minute_hand.rotation = deg_to_rad(minute_angle)
	date.text = TimeManager.get_date_string()

