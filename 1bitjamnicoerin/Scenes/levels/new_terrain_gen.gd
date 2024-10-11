extends Node2D


@export var start_section: PackedScene

@export var sections: Array[PackedScene]

@export var transition_section: PackedScene

@export var sections_count := 10


func _ready() -> void:
	var start_instance = start_section.instantiate()
	
	add_child(start_instance)
	
	for i in range(sections_count):
		var section_instance = sections.pick_random().instantiate()
		
		add_child(section_instance)
		
		var height = section_instance.get_node("tilemap_layer_collision").get_used_rect().size.y * 32
		
		section_instance.global_position.y = height * -(i + 1)
