extends Node

@onready var _animated_snake_tongue_sprite = $Snake_Animated_Sprite
@onready var _animated_snake_sprite = $Snake_Tongue_Animated_Sprite
@onready var _animated_snake_eye_sprite_A = $Snake_Eye_A
@onready var _animated_snake_eye_sprite_B = $Snake_Eye_B
@onready var _animated_snake_eye_sprite_C = $Snake_Eye_C

var interval = 1.5  # Call the function every 2 seconds
var time_left = interval  # Start the countdown
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_snake_tongue_sprite.play("IDLE")
	_animated_snake_sprite.play("IDLE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		time_left = interval  # Reset the timer
		call_repeated_function()

# Function to be called every 2 seconds
func call_repeated_function():
	_Blinks()


func _Blinks():
	for i in range(4):
		if i == 1 :
			await get_tree().create_timer(.2).timeout
			_animated_snake_eye_sprite_A.play("IDLE")
		if i == 2 :
			await get_tree().create_timer(.2).timeout
			_animated_snake_eye_sprite_B.play("IDLE")
		if i == 3 :
			await get_tree().create_timer(.2).timeout
			_animated_snake_eye_sprite_C.play("IDLE")
			
		
