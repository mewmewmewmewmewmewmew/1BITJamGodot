extends Node

var my_tileset_dict = {
	Vector2i(5, 5): Vector2i(2, 0),
	Vector2i(10, 10): Vector2i(2, 0),
	Vector2i(15, 15): Vector2i(2, 0),
	Vector2i(20, 20): Vector2i(2, 0)
}


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

var neighborhood_height = 3
var neighborhood_width = 3

@onready var tilemap : TileMapLayer = $TileMapLayer3

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
			
			
	
func set_cells_from_tileset_dict():
	# Correct dictionary reference and properly set tiles in tilemap
	for position in my_tileset_dict:
		var tile_position = my_tileset_dict[position]
		tilemap.set_cell(position, 0, Vector2i(randi_range(3,4),randi_range(0,1))) # Assuming (0) is the layer
		print("Set tile at:", position, "with tile:", tile_position)

func _ready():
	fill_tileset_dict()  # Fill the dictionary first
	set_cells_from_tileset_dict()  # Then apply the dictionary to the tilemap
