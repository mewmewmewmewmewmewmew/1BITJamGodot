extends Node2D

@export var radius := 50.0
@export_enum("clockwise", "counter clockwise","horizontal","vertical","diag1","diag2") var mode := "clockwise"
@export var duration := 5.0
var x:float
var pos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos = global_position
	$Timer.wait_time = duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	x = ($Timer.time_left/$Timer.wait_time)*PI*2
	if mode == "clockwise":
		global_position.y = pos.y + sin(-x)*radius
		global_position.x = pos.x + cos(x)*radius
	elif mode == "counter clockwise":
		global_position.y = pos.y + sin(x)*radius
		global_position.x = pos.x + cos(x)*radius
	elif mode == "horizontal":
		global_position.x = pos.x + cos(x)*radius
	elif mode == "vertical":
		global_position.y = pos.y + sin(x)*radius
	elif mode == "diag1":
		global_position.y = pos.y + cos(x)*radius
		global_position.x = pos.x + cos(x)*radius
	elif mode == "diag2":
		global_position.y = pos.y + sin(-x)*radius
		global_position.x = pos.x + sin(x)*radius
	#print(sin(x*PI)*delta_y)
	
