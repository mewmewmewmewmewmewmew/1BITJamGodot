extends Node



var my_tileset_dict = {
	Vector2i(5, 5): Vector2i(2, 0),
	Vector2i(10, 10): Vector2i(2, 0),
	Vector2i(15, 15): Vector2i(2, 0),
	Vector2i(20, 20): Vector2i(2, 0)
}
var bg_tile = Vector2i(0,4)
var bg_brick = Vector2i(0,3)
var pass_through_brick = Vector2i(0,0)
var solid_brick = Vector2i(1,0)
var unstable_brick = Vector2i(1,1)
var heart_eye = Vector2i(3,0)

var my_walker_position = Vector2i(-10,12)
var my_tileset_states_dict = {
	Vector2i(0,0): 0
}

var my_tileset_neighbor_count = {
	Vector2i(0,0): 0
}
var my_tileset_neighbor_positions_dict = {
	Vector2i(0,0): [Vector2i(0,0),Vector2i(1,1)]
}
var my_tileset_max_height = 100
var my_tileset_max_width = 100

var chunk_height = 12
var chunk_amount = 10

var neighborhood_height = 3
var neighborhood_width = 3

@onready var Collision_Tile_Map : TileMapLayer = $Collision_Tile_Map_Layer
@onready var BG_Tile_Map : TileMapLayer = $BG_Tile_Map_Layer

func fill_tileset_dict():
	# Iterate over width and height and add to the dictionary
	for x in range(my_tileset_max_width):
		for y in range(my_tileset_max_height):
			my_tileset_dict[Vector2i(x-(my_tileset_max_width/2), y-(my_tileset_max_width/2))] = Vector2i(0, 0)  # Fixed Vector2i constructor

func check_tileset_dict_states():
	for x in range(my_tileset_max_width):
		for y in range(my_tileset_max_height):
			var key_position = Vector2i(x,y)
			check_neighbors(key_position)
	
	
func check_neighbors(current_key_position: Vector2i):
	var neighbors
	for x in range(-neighborhood_width / 2, neighborhood_width / 2):
		for y in range(-neighborhood_height / 2, neighborhood_height / 2):
			if x == 0 and y == 0:
				continue
			var neighbor_position = current_key_position + Vector2i(x, y)
			if my_tileset_states_dict.has(neighbor_position):
				neighbors+=1
			
			
func stack_patterns():
	var _pattern = TileMapPattern.new()
	var _position = Vector2i(0,0)
	for y in range(chunk_amount):
		_position = Vector2i(0, chunk_amount*chunk_height)
		Collision_Tile_Map.set_pattern(_position, _pattern)
	
	
func set_cells_from_tileset_dict():
	# Correct dictionary reference and properly set tiles in Collision_Tile_Map
	for position in my_tileset_dict:
		var tile_position = my_tileset_dict[position]
		Collision_Tile_Map.set_cell(position, 0, Vector2i(randi_range(3,4),randi_range(0,1))) # Assuming (0) is the layer
		print("Set tile at:", position, "with tile:", tile_position)
		
func run_random_walker(iterations):
	for i in range(iterations):
		var new_direction = Vector2i(randi_range(-3,3),-1)
		my_walker_position += new_direction
		if my_walker_position.x > -6 :
			my_walker_position.x-= 5
		if my_walker_position.x < -14 :
			my_walker_position.x+= 5
		Collision_Tile_Map.set_cell(my_walker_position, 0, Vector2i(0,4) )
		for x in range(randi_range(-3,-1),randi_range(0,3)):
			for y in range(randi_range(-3,-1),randi_range(0,3)):
				Collision_Tile_Map.set_cell(my_walker_position + Vector2i(x,y), 0, bg_tile)
				if x == randi_range(-2,2):
					Collision_Tile_Map.set_cell(my_walker_position + Vector2i(x,y), 0, bg_brick)
		print("where my walker should be:", my_walker_position)
		#if iteration is divisible by rand number between 7 and 17, then replace with eye semi closed heart tile
		#if i%randi_range(7,17) == 0 :
			#Collision_Tile_Map.set_cell(my_walker_position, 0, Vector2i(3,2))
		#if iteration is divisible by a random number between 6 and 16, then replace with partially destroyed tile
		if i%randi_range(6,16) == 0 :
			Collision_Tile_Map.set_cell(my_walker_position, 0, unstable_brick)
		#if iteration is divisible by 5, then spwn a partial black brick tile
		if i%5 == 0 :
			BG_Tile_Map.set_cell(my_walker_position, 0, bg_brick)
			for j in range(randi_range(1,3)) :
				BG_Tile_Map.set_cell(my_walker_position + Vector2i(randi_range(-1,1),randi_range(-1,1)), 0, bg_brick)
		#Create heart at end of 99 iterations
		if i >= 99 :
			Collision_Tile_Map.set_cell(my_walker_position, 0, heart_eye )
		await get_tree().create_timer(0.5).timeout
		
func run_turning_walker():
	for i in range(randi_range(3,5)):
		var north_direction = Vector2i(0,-1)
		var west_direction = Vector2i(-1,2)
		var east_direction = Vector2i(-1,2)
		var current_direction = north_direction
		#choose to turn left or right
		
func _ready():
	#fill_tileset_dict()  # Fill the dictionary first
	#set_cells_from_tileset_dict()  # Then apply the dictionary to the Collision_Tile_Map
	run_random_walker(100)
