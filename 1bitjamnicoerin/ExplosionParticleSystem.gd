extends Node2D

var explosion_a = load("res://Scenes/VFX/Explosion_A_Anim.tscn")
var explosion_b = load("res://Scenes/VFX/Explosion_B_Anim.tscn")
var explosion_c = load("res://Scenes/VFX/Explosion_C_Anim.tscn")
var number_of_objects = 10
var radius
		
func _call_all_explosions():
	await get_tree().create_timer(0).timeout
	_call_explode(explosion_a, 6)
	await get_tree().create_timer(.2).timeout
	_call_explode(explosion_b, 8)
	await get_tree().create_timer(.4).timeout
	_call_explode(explosion_c, 12)
	
func _call_explode(explosion, explosion_count):
	for i in range(10):
		# Calculate the angle for the current object
		
		var angle = i * (PI * 2 / explosion_count)
		radius = randi_range(20,50)
		# Calculate the position based on the angle and radius
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		var position = Vector2(x, y)
		var explosion_A_Instance = explosion.instantiate()
		add_child(explosion_A_Instance)
		explosion_A_Instance.position = position
	
