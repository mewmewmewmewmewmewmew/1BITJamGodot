extends Area2D
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $".."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_overlapping_areas() == true and player.invincible == false:
		print('taunty')
		
