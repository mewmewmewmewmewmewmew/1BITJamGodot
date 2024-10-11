extends Node2D


@export var start_section: PackedScene

@export var sections: Array[PackedScene]

@export var transition_section: Array[PackedScene]

@export var sections_count := 10


func _ready() -> void:
	generate_terrain()


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Y):
		generate_terrain()


func generate_terrain():
	for child in get_children():
		child.queue_free()
	
	var start_instance = start_section.instantiate()
	
	add_child(start_instance)
	
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
