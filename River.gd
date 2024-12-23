extends Node2D
"""

var size = Vector2i(100, 100)
var riverStarters = 5
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
	#"1,0,1,0,1,0": Vector2i(10,0),
	"1,0,1,1,0,0": Vector2i(11,0),
	"1,0,1,0,0,1": Vector2i(12,0),
	"0,0,1,0,1,1": Vector2i(14,0),
	"1,0,1,1,1,0": Vector2i(15,0),
	"1,0,1,0,1,1": Vector2i(16,0),
	"0,0,1,0,0,1": Vector2i(0,1),
	"0,0,1,0,1,0": Vector2i(1,1),
	"0,0,0,1,0,1": Vector2i(2,1),
	"1,1,0,1,0,0": Vector2i(3,1),
	#"0,1,0,1,0,1": Vector2i(4,1),
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
	
}
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
		var tileData = tiles[Vector2i(x,y)]
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
	if !(Vector2i(x,y ) in tiles):
		print("No tile at:", Vector2i(x, y), "Skipping.")
		return
	var tileData = tiles[Vector2i(x, y)]
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

