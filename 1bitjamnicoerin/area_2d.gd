extends Area2D
signal show_arrow(pos,rot) 
signal hide_arrow()
signal dash_ready(dir)
signal dash_unready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_overlapping_areas() == true:
		#finds the closest overlapping object
		var closest = null #stores the closest overlapping object
		for i in get_overlapping_areas():
			if closest == null:
				closest = i
			elif global_position.distance_to(i.global_position) < global_position.distance_to(closest.global_position):
				closest = i
		
		#finds the angle(from +x) in degrees
		var x = global_position.direction_to(closest.global_position)
		var rot = x.angle() + PI/2
		show_arrow.emit(closest.global_position, rot)
		dash_ready.emit(x)

	else:
		hide_arrow.emit()
		dash_unready.emit()
		
