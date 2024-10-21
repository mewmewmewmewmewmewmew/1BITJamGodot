extends Node2D


@export var start_section: PackedScene

@export var sections: Array[PackedScene]

@export var transition_section: Array[PackedScene]

@export var sections_count := 10

var _start_section_node: Node2D
var _player_spawn_point: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Y):
		generate_terrain()


func place_player(player):
	if _start_section_node == null:
		return
	
	_start_section_node.add_child(player)
	player.global_position = _player_spawn_point


func generate_terrain():
	for child in get_children():
		child.queue_free()
	
	_start_section_node = start_section.instantiate()
	add_child(_start_section_node)
	
	if _start_section_node.has_node("PlayerSpawnPoint"):
		_player_spawn_point = _start_section_node.get_node("PlayerSpawnPoint").global_position
	
	for i in range(sections_count):
		var transition_instance = transition_section.pick_random().instantiate()
		var height = -get_total_height()
		
		transition_instance.global_position.y = height
		add_child(transition_instance)
		
		var section_instance = sections.pick_random().instantiate()
		height = -get_total_height()
		
		section_instance.global_position.y = height
		add_child(section_instance)


func get_total_height() -> int:
	var sum = 0
	for child in get_children():
		sum += child.get_node("tilemap_layer_collision").get_used_rect().size.y * 32
	
	return sum
