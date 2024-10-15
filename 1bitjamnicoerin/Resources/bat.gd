extends Node2D

@export var radius := 50.0
@export_enum("clockwise", "counter clockwise","horizontal","vertical","diag1","diag2") var mode := "clockwise"
@export var duration := 5.0
@export var time_offset := 0.0
@export var respawn_time := 2.0

var x:float
var pos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos = global_position
	$Timer.wait_time = duration
	$respawn_timer.wait_time = respawn_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	x = (($Timer.time_left-time_offset)/$Timer.wait_time)*PI*2
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
	

func _on_area_2d_damage() -> void:
	$Area2D/CollisionShape2D.disabled = true #turns off the slash dash point
	$Area2D_damage/CollisionShape2D.disabled = true #turns off damage
	$ExplosionParticleSystem._call_all_explosions()
	$AnimatedSprite2D.play("DAZED")
	#$Timer.paused = true #pauses movement
	$respawn_timer.start()
	
func _on_respawn_timer_timeout() -> void:
	$Area2D/CollisionShape2D.disabled = false #turns off the slash dash point
	$Area2D_damage/CollisionShape2D.disabled = false #turns off damage
	$AnimatedSprite2D.play("IDLE")
	#$Timer.paused = false #pauses movement
