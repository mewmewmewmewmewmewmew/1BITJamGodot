extends Area2D
signal show_arrow(pos,rotation)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_overlapping_areas() == true:
		for i in get_overlapping_areas():
			print(i.global_position)
