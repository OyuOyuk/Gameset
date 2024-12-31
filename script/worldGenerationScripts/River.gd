extends Node2D

var size = Vector2i(100, 100)
@export var riverTileMap : TileMap
var riverStartCount = 5
var riverTileSet = {
	"1,0,0,0,1,0":Vector2i(0, 0),
	"1,0,0,1,0,0": Vector2i(1,0),
	"1,0,1,0,0,0": Vector2i(2,0),
	"0,1,0,0,0,1": Vector2i(3,0),
	"0,1,0,0,1,0": Vector2i(4,0),
	"0,1,0,1,0,0": Vector2i(5,0),
	"1,1,0,0,1,0": Vector2i(6,0),
	"1,0,1,0,1,0": Vector2i(7,0),
	"0,1,1,0,1,0": Vector2i(8,0),
	"1,0,0,1,1,0": Vector2i(9,0),
	"0,1,1,0,1,1": Vector2i(10,1),
	"1,0,1,1,0,0": Vector2i(11,0),
	"1,0,1,0,0,1": Vector2i(12,0),
	"0,0,1,0,1,1": Vector2i(14,0),
	"1,0,1,1,1,0": Vector2i(15,0),
	"1,0,1,0,1,1": Vector2i(16,0),
	"0,0,1,0,0,1": Vector2i(0,1),
	"0,0,1,0,1,0": Vector2i(1,1),
	"0,0,0,1,0,1": Vector2i(2,1),
	"1,1,0,1,0,0": Vector2i(3,1),
	"1,0,1,1,0,1": Vector2i(4,1),
	"1,0,0,1,0,1": Vector2i(5,1),
	"0,1,1,0,0,1": Vector2i(6,1),
	"0,1,0,1,0,1": Vector2i(7,1),
	"0,0,1,1,0,1": Vector2i(8,1),
	"0,1,0,0,1,1": Vector2i(9,1),
	"0,1,0,1,1,0": Vector2i(11,1),
	"1,1,0,1,0,1": Vector2i(12,1),
	"1,1,1,0,1,0": Vector2i(13,1),
	"0,1,1,1,0,1": Vector2i(14,1),
	"0,1,0,1,1,1": Vector2i(15,1),
	"1,1,1,1,1,1": Vector2i(10,0),
	
}
func _ready():
	
	generateRivers()
	riverTiler()
func generateRivers():
	var x = -size.x/2
	var y = -size.y/2
	var riverStarterOptions = []
	var riverStarters = []
	var riverDirection
	for xv in range(-size.x/2, size.x/2):
		if WorldManager.get_chunk(Vector2i(xv,y)) != null:
			riverStarterOptions.append(Vector2i(xv,y))
	for yv in range(-size.y/2, size.y/2):
		if WorldManager.get_chunk(Vector2i(x,yv)) != null:
			riverStarterOptions.append(Vector2i(x,yv))
	for time in range(riverStartCount):
		randomize()
		riverStarters.append(riverStarterOptions.pick_random())
	print(riverStarters)
	var nogozone 
	for river in riverStarters:
		if river.x == -50:
			riverDirection = [0, 0, 0, 1, 0, 0]
			WorldManager.get_chunk(river).river_connection = [2, 0, 0, 1, 0, 0]
			nogozone = [0, 1, 5]
		elif river.y == -50:
			riverDirection = [0, 0, 0, 0, 1, 0]
			WorldManager.get_chunk(river).river_connection = [0, 2, 0, 0, 1, 0]
			nogozone = [0, 1, 2]
		var next = neighborFinder(river, riverDirection)
		print(next)
		
		riverDirector(next,riverDirection, nogozone)
func neighborFinder(pos: Vector2i, direction):
	# Check if the column is even or odd
	var is_even_column = pos.x % 2 == 0

	# Define neighbor offsets for even and odd columns
	var directions_even = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # Down
		"0,1,0,0,0,0": Vector2i(0, -1), # Up
		"0,0,1,0,0,0": Vector2i(1, 0),  # Right-Up
		"1,0,0,0,0,0": Vector2i(-1, 0), # Left-Up
		"0,0,0,1,0,0": Vector2i(1, 1),  # Right-Down
		"0,0,0,0,0,1": Vector2i(-1, 1)  # Left-Down
	}

	var directions_odd = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # Down
		"0,1,0,0,0,0": Vector2i(0, -1), # Up
		"0,0,1,0,0,0": Vector2i(1, -1), # Right-Up
		"1,0,0,0,0,0": Vector2i(-1, -1), # Left-Up
		"0,0,0,1,0,0": Vector2i(1, 0),  # Right-Down
		"0,0,0,0,0,1": Vector2i(-1, 0)  # Left-Down
	}

	# Select directions based on column parity
	var directions = directions_odd if is_even_column else directions_even

	# Return the new position
	return pos + directions[",".join(direction)]

func riverDirector(pos : Vector2i, incomingDirection, nogozone):
	
	var direction = incomingDirection.duplicate() #direction means like the where the river comes from Incoming means where the river is from the old chunks
	for item in range(direction.size()):
		direction[item] = incomingDirection[(item + 3) % incomingDirection.size()]
	var incomingIndex = direction.find(1)
	var occupiedSides = []
	occupiedSides.append(incomingIndex)
	occupiedSides.append((incomingIndex-1+6)%6)
	occupiedSides.append((incomingIndex+1)%6)
	occupiedSides.append_array(nogozone)
	if WorldManager.get_chunk(pos).river_connection != [0, 0, 0, 0, 0, 0]:
		riverMerger(pos, incomingIndex)
		return
	var unoccupiedSides = []
	for i in range(6):
		if i not in occupiedSides:
			unoccupiedSides.append(i)
	var outgoingIndex = unoccupiedSides.pick_random()
	WorldManager.get_chunk(pos).river_connection[outgoingIndex] = 1
	WorldManager.get_chunk(pos).river_connection[incomingIndex] = 2
	#print(WorldManager.get_chunk(pos).river_connection)
	
	var outgoingDirection = [0, 0, 0, 0, 0, 0]
	outgoingDirection[outgoingIndex] = 1
	var next = neighborFinder(pos, outgoingDirection)
	#print(next)
	if WorldManager.check_chunk(next):
		riverDirector(next, outgoingDirection, nogozone)
func riverMerger(pos : Vector2i, incomingIndex):
	if (WorldManager.get_chunk(pos).river_connection[(incomingIndex-1+6)%6] == 2 or WorldManager.get_chunk(pos).river_connection[(incomingIndex+1)%6]  == 2 ) and WorldManager.get_chunk(pos).river_connection[incomingIndex] == 1:
		WorldManager.get_chunk(pos).river_connection = [1,1,1,1,1,1]
	if WorldManager.get_chunk(pos).river_connection.count(1) > 3:
		WorldManager.get_chunk(pos).river_connection = [1,1,1,1,1,1]
	else:
		WorldManager.get_chunk(pos).river_connection[incomingIndex] = 1
			
func changer(connections):
	for index in range(connections.size()):
		if connections[index] == 2:
			connections[index] = 1
	return connections
func riverTiler():
	for x in range(-size.x/2, size.x/2):
		for y in range(-size.y/2, size.y/2):
			var timer =WorldManager.get_chunk(Vector2i(x,y)).river_connection[5]

			for i in range(5):
				if WorldManager.get_chunk(Vector2i(x,y)).river_connection[i] == 1:
					timer = timer + 1
				elif WorldManager.get_chunk(Vector2i(x,y)).river_connection[i] != 1:
					timer = 0
				if timer >= 3:
					WorldManager.get_chunk(Vector2i(x,y)).river_connection = [1, 1, 1, 1, 1, 1]
					continue
			if WorldManager.get_chunk(Vector2i(x,y)).river_connection != [0, 0, 0, 0, 0, 0] and WorldManager.get_chunk(Vector2i(x,y)).biome != "WATER": 
				if  riverTileSet.has(",".join(changer(WorldManager.get_chunk(Vector2i(x,y)).river_connection))):
					riverTileMap.set_cell(1, Vector2i(x,y), 2, riverTileSet[",".join(changer(WorldManager.get_chunk(Vector2i(x,y)).river_connection))] )	
				else:
					WorldManager.get_chunk(Vector2i(x,y)).river_connection = [1, 1, 1, 1, 1, 1]
					riverTileMap.set_cell(1, Vector2i(x,y), 2, riverTileSet[",".join(changer(WorldManager.get_chunk(Vector2i(x,y)).river_connection))])
					
"""
func generateRivers():
	print("Generating rivers...")
	var rng = RandomNumberGenerator.new()
	for start in range(riverStarters):
		randomize()
		rng.randomize()
		var random_binary = randi() % 4
		var x
		var y
		var direction
		match random_binary:
			0:
				direction = [0, 0, 1, 0, 0, 0]
				x = -size.x/2 + 1
				y = rng.randf_range(-size.y/2, size.y/2)
			1: 
				direction = [0, 0, 0, 0, 1, 0]
				y = -size.y/2 + 1
				x = rng.randf_range(-size.x/2, size.x/2)
			2:	
				direction = [0, 0, 0, 0, 0, 1]
				x = size.x/2 - 1
				y = rng.randf_range(-size.y/2, size.y/2)
			3:	
				direction = [0, 1, 0, 0, 0, 0]
				y = size.y/2 -1
				x = rng.randf_range(-size.x/2, size.x/2)
		print("River starting at:", Vector2i(x, y), " with direction:", direction)
		var tileData =WorldManager.get_chunk(Vector2i(x, y))
		tileData.river_connection = direction

		var neighbor = neighborFinder(x, y, ",".join(direction))
		if y < 50 and x < 50 and x > -50 and y > -50:
			riverDirector(x + neighbor.x, y + neighbor.y, direction)
	print("River generation complete.")
# In the neighborFinder function, make sure to properly move by one tile at a time based on direction
func neighborFinder(x, y, direction):
	print("Finding neighbor for:", Vector2i(x, y), "with direction:", direction)
	
	# Direction vector mapping for flat-topped hexagons
	var directions = {
		"0,0,0,0,1,0": Vector2i(0, 1),  # move down (South)
		"0,1,0,0,0,0": Vector2i(0, -1), # move up (North)
		"0,0,1,0,0,0": Vector2i(1, 0),  # move right (East)
		"0,0,0,0,0,1": Vector2i(-1, 0), # move left (West)
		"0,0,0,1,0,0": Vector2i(1, 1),  # move down-right (Southeast)
		"1,0,0,0,0,0": Vector2i(-1, -1)  # move up-left (Northwest)
	}
	
	# Get the movement vector for the current direction
	var move = directions.get(direction, Vector2i(0, 0))  # default to no movement
	
	# Calculate the new position
	var neighbor_position = Vector2i(x, y) + move
	print("Neighbor position:", neighbor_position)
	
	# Ensure the neighbor is within bounds of the map
	if neighbor_position.x < -size.x / 2 or neighbor_position.x >= size.x / 2 or neighbor_position.y < -size.y / 2 or neighbor_position.y >= size.y / 2:
		print("Neighbor out of bounds:", neighbor_position)
		return Vector2i(x, y)  # Return the same position if out of bounds
	
	return neighbor_position

func riverDirector(x,y, direction):
	print("DEBUG: Finding neighbor for tile:", Vector2i(x, y))
	print("DEBUG: Direction vector received:", direction)
	print("Directing river from:", Vector2i(x, y), " with direction:", direction)

	var tileData =WorldManager.get_chunk(Vector2i(x, y))
	var sides = direction.duplicate()
	var len = direction.size() # Copy the array to avoid modifying the original
	var n = 2
	# Ensure n is within bounds (wrap it around if n is larger than the array size)
	n = n % len
	for i in range(len):
		sides[i] = direction[(i + n) % len]
	var indexes = []
	for i in range(sides.size()):
		if sides[i] == 1:
			indexes.append(i)
	var before
	var after
	var occupied =[]
	for index in indexes:
		if index - 1 == 0:
			before = "top"
		elif index -1 ==1:
			before = "right"
		elif index -1 == 2:
			before = "bottom"
		elif index -1 == 3:
			before = "left"
		occupied.append(before) 
	print("Occupied sides:", occupied)
	return
	"""

