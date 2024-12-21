extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false
var zoom_step = 0.1  # Adjust the zoom step size as needed
var max_zoom_in = Vector2(0.5, 0.5)  # Maximum zoom-in limit
var max_zoom_out = Vector2(2.0, 2.0)  # Maximum zoom-out limit

func _input(event):
	# Handle drag
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		# Adjust drag speed based on the current zoom level
		var adjusted_offset = (mouse_start_pos - event.position) * zoom
		position = screen_start_position + adjusted_offset

	# Handle zoom
	elif event is InputEventMouseButton:
		if event.is_action("zoomOut"):  # Zoom in
			zoom = (zoom - Vector2(zoom_step, zoom_step)).clamp(max_zoom_in, max_zoom_out)
		elif event.is_action("zoomIn"):  # Zoom out
			zoom = (zoom + Vector2(zoom_step, zoom_step)).clamp(max_zoom_in, max_zoom_out)
