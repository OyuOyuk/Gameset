extends TileMap

var water_material: ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectionManager.time_of_day.connect(change)
	
func change(time_of_day):
	var state 
	if time_of_day == "morning":
		state = 0
	elif time_of_day == "afternoon":
		state = 1
	elif time_of_day == "evening":
		state = 2
	elif time_of_day == "night":
		state = 3
	#water_material.set_shader_parameter("day_time", state) # change this to hint coloraw
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
