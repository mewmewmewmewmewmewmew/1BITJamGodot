extends Node

@onready var _animated_snake_tongue_sprite = $Snake_Animated_Sprite
@onready var _animated_snake_sprite = $Snake_Tongue_Animated_Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_snake_tongue_sprite.play("IDLE")
	_animated_snake_sprite.play("IDLE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _call_Blinks():
	for i in range(3):
		
		pass
