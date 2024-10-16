extends Node2D

var explosion_a = load("res://Scenes/VFX/Explosion_A_Anim.tscn")
var explosion_b = load("res://Scenes/VFX/Explosion_B_Anim.tscn")
var explosion_c = load("res://Scenes/VFX/Explosion_C_Anim.tscn")
var number_of_objects = 10
var radius
		
func _call_all_explosions():
	await get_tree().create_timer(0).timeout
	_call_explode(explosion_b, 4,4,12,12)
	await get_tree().create_timer(.05).timeout
	_call_explode(explosion_a, 3,3,10,10)
	await get_tree().create_timer(.4).timeout
	_call_explode(explosion_c, 5,5,15,15)
	
func _call_explode(explosion, explosion_count_min, explosion_count_max, radius_min, radius_max):
	var randomized_explosion_count = randi_range(explosion_count_min,explosion_count_max)
	for i in range(randomized_explosion_count):
		# Calculate the angle for the current object
		await get_tree().create_timer(0.01).timeout
		var angle = i * (PI * 2 / randomized_explosion_count)
		radius = randi_range(radius_min, radius_max)
		# Calculate the position based on the angle and radius
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		var position = Vector2(x, y)
		var explosion_A_Instance = explosion.instantiate()
		add_child(explosion_A_Instance)
		explosion_A_Instance.position = position
	
