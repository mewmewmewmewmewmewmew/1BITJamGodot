extends Node2D

@export var borders: Array[PackedScene]
@export var tiles: Array[PackedScene]

var tile_pos = Vector2(0,0) #the global reference point for the tile generator. 0,0 is bottom left and 1,1 is top right, height is global. see notebook for details
var tile_dir = 4 #the compass direction (relative) reference point for the tile generator. see notebook for details



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var main_index = [] #idk why but this has to be in _ready even though its a constant look up table
	main_index.append([1, 1, 1, 1, 1, 1, 1, 1]) #tile1
	main_index.append([1, 1, 0, 0, 0, 0, 0, 1]) #tile2
	main_index.append([2, 2, 1, 1, 1, 1, 1, 2]) #tile3
	main_index.append([2, 1, 1, 1, 3, 1, 1, 1]) #tile4
	main_index.append([1, 2, 2, 1, 1, 1, 1, 2]) #tile5
	main_index.append([1, 1, 1, 1, 0, 1, 1, 1]) #tile6

	
	
	generate_level(main_index)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_level(main_index) -> void:
	
	var room_length = [3, 3, 3, 3, 3, 3].pick_random() #decrements as each tile is generated
	
	if room_length == 3:
		
		#creates the walls around the border of the room
		var room = borders[0].instantiate()
		room.position.y = -256*tile_pos.y
		add_child(room)
		
		print("tile_pos: ", tile_pos)
		print("tile_dir: ", tile_dir)
		#generates the first room
		var delta = ["vertical", "horizontal","diagonal"].pick_random()
		var temp = generate_tile(tile_pos, tile_dir, delta, main_index)
		tile_pos = temp[0]
		tile_dir = wrap_dir(temp[1])
		print(delta)
		print("")
		
		#generates the second room
		print("tile_pos: ", tile_pos)
		print("tile_dir: ", tile_dir)
		var delta2 = ""
		if delta == "horizontal":
			delta2 = ["vertical", "diagonal"].pick_random()
			temp = generate_tile(tile_pos, tile_dir, delta2, main_index)
			tile_pos = temp[0]
			tile_dir = wrap_dir(temp[1])
		else:
			delta2 = "horizontal"
			temp = generate_tile(tile_pos, tile_dir, delta2, main_index)
			tile_pos = temp[0]
			tile_dir = wrap_dir(temp[1])
		print(delta2)
		print("")
		
		#generates the third room
		print("tile_pos: ", tile_pos)
		print("tile_dir: ", tile_dir)
		var delta3 = ["vertical", "diagonal"].pick_random()
		temp = generate_tile(tile_pos, tile_dir, delta, main_index)
		tile_pos = temp[0]
		tile_dir = temp[1]
		print(delta3)
		print("")
		
func generate_tile(tile_pos, tile_dir, delta, main_index):
	var next_tile_dir = 0 #compass direction
	var next_tile_pos = tile_pos #2d tile coordinate
	#choose next_tile_dir and pos
	if delta == "diagonal":
		if tile_pos.x == 0:
			next_tile_dir = 1
			next_tile_pos.x = 1
			next_tile_pos.y += 1
		else:
			next_tile_dir = 7
			next_tile_pos.x = 0
			next_tile_pos.y += 1
	if delta == "vertical":
		next_tile_dir = [0,1,7].pick_random()
		next_tile_pos.y += 1
	elif delta == "horizontal":
		if tile_pos.x == 0:
			next_tile_dir = [1,2,3].pick_random()
			next_tile_pos.x = 1
		else:
			next_tile_dir = [7,6,5].pick_random()
			next_tile_pos.x = 0
	
	#randomly picks a valid tile based on tile_dir and next_tile_dir
	var i = null
	var temp = []
	for t in range(len(main_index)):
		temp.append(t)
	temp.shuffle()
	for e in temp:
		var t = main_index[e]
		if t[tile_dir] == 2 or t[tile_dir] == 1:
			if t[next_tile_dir] == 3 or t[tile_dir] == 1:
				i = e
				break
	print(i)
	var tile = tiles[i].instantiate()
	tile.position.x = -128 + 256*tile_pos.x
	tile.position.y = -224*tile_pos.y
	add_child(tile)
	print("next_tile_pos: ", next_tile_pos)
	print("next_tile_dir: ", next_tile_dir)
	return [next_tile_pos, next_tile_dir]
	
func wrap_dir(dir): #gives the complement of the compass direction
	var out = null
	if dir < 4:
		out = dir + 4
	else:
		out = dir - 4
	return out
