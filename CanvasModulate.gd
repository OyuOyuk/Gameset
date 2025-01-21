extends CanvasModulate

var turn = [Color(1, 0.9, 0.7, 1), Color(1, 1, 1, 1), Color(0.8, 0.5, 0.5, 1), Color(0.2, 0.2, 0.5, 1)]
var current_color: Color = Color(1, 1, 1, 1)
var target_color: Color = Color(1, 1, 1, 1)
var transition_speed: float = 0.01  # Adjust for smoothness (lower is slower)
var day_time_change = TimeManager.day_time_change
func _ready():
	ConnectionManager.connect("daytime_change", update_lighting)
	set_process(true)

func _process(delta):
	# Gradually interpolate towards the target color
	if current_color != target_color:
		current_color = current_color.lerp(target_color, transition_speed)
		color = current_color

func update_lighting(current_hour):
	# Determine target color based on the time
	if current_hour >= day_time_change[0] and current_hour < day_time_change[1]:
		target_color = turn[0]
	elif current_hour >= day_time_change[1] and current_hour < day_time_change[2]: 
		target_color = turn[1]
	elif current_hour >= day_time_change[2] and current_hour < day_time_change[3]:
		target_color = turn[2]
	elif current_hour >= day_time_change[3] or current_hour < day_time_change[0]:
		target_color = turn[3]
	print("Time =", current_hour, "Target color =", target_color)
