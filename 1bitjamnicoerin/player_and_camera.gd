extends Node
@export var y_offset := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera2D.global_position = Vector2($Camera2D.global_position.x, $player.global_position.y + y_offset)
