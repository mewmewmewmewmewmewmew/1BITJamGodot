extends CharacterBody2D

@onready var animated_sprite = $BatSprite2D
@onready var anim_trans = $"../Transition"
@export var ACCEL = 10
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
@export var DASH_SPEED = 300

var jump_f := false #jump flag, allows the player to jump
var dash_f := false #dash flag, allows the player to dash
var dash_dir = null #stores the normalized direction pointing to the dash target
var walljump_f := true #walljump flag, allows the player to jump from a wall cling; resets on dash or ground touch
var clingfacing = 0 #player facing for wallclings, should be -1 for left or 1 for right
var state = "move"
var invincible = false #for dashing through enemies
var triggered = false
var death_timer_triggered = false
signal fade_out



func _physics_process(delta: float) -> void:
	if state == "move":
		animated_sprite.play("IDLE")
		#handles dash
		if Input.is_action_just_pressed("ui_dash") and dash_f == true:
			$"../FMOD BASIC/Slash".play()
			collision_mask = 0b0001 #turns one way collisions back of
			$dash_timer.start() #ends the dash after a certain amount of time
			velocity = DASH_SPEED * dash_dir
			invincible = true
			state = "dash"
			#destroys certain destructible objects
			if $Area2D.closest.has_method("die"):
				$Area2D.closest.die()
		else:
			player_move(delta)
	if state == "dash":
		animated_sprite.play("DASH")
		player_dash(delta)
	if state == "wall cling":
		animated_sprite.play("WALLCLING")
		player_wallcling()

func player_move(delta):
	if is_on_floor() and $floor_lockout.is_stopped():
		print
		jump_f = true
		$coyote_timer.stop()
	# Add the gravity.
	else:
		if state != "dead": 
			velocity += (get_gravity()/2) * delta
		if $coyote_timer.is_stopped() == true and jump_f == true:
			$coyote_timer.start() #the timer event is at the bottom of this script

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and jump_f == true and state != "dead" :
		velocity.y = JUMP_VELOCITY
		$"../FMOD BASIC/Jump".play()
		jump_f = false
		$coyote_timer.stop()

	#handles horizontal movement
	if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right") and state != "dead" : #make sure only left xor right is pressed
		if Input.is_action_pressed("ui_left"): #this is pressing left
			if velocity.x > 0:
				velocity.x -= ACCEL*2 #double ACCEL for reverse movement
			else:
				#accelerate under the speed limit, decay above it
				if velocity.x > -SPEED: #accelerate
					velocity.x -= ACCEL
					if velocity.x < -SPEED: #enforces speed limit
						velocity.x = -SPEED
				else: #decay
					velocity.x += ACCEL
					if velocity.x > -SPEED: #handles overshoot
						velocity.x = -SPEED
		else: #this is pressing right
			if velocity.x < 0:
				velocity.x += ACCEL*2 #double ACCEL for reverse movement
			else:
				#accelerate under the speed limit, decay above it
				if velocity.x < SPEED: #acclerate
					velocity.x += ACCEL
					if velocity.x > SPEED: #enforces speed limit
						velocity.x = SPEED
				else: #decay
					velocity.x -= ACCEL
					if velocity.x < SPEED: #handles overshoot
						velocity.x = SPEED
			
	else: #both or none are pressed
		#deccel code
		if velocity.x < 0:
			velocity.x += ACCEL
			if velocity.x > 0: #handles overshoot
				velocity.x = 0
		if velocity.x > 0:
			velocity.x -= ACCEL
			if velocity.x < 0: #handles overshoot
				velocity.x = 0

	move_and_slide()

func player_dash(delta):
	var x = move_and_collide(velocity*delta)
	#code for initiating wallclings
	if x != null:
		if x.get_normal() == Vector2(1, 0): #if colliding with a right facing wall
			collision_mask = 0b0011 #turns one way collisions back on
			invincible = false #for dashing through enemies
			position += Vector2(1,0) #prevents clipping
			state = "wall cling"
			jump_f = false
			clingfacing = 1
			velocity = Vector2(0,0)
			$wallcling_timer.start()
			$dash_timer.stop()
			$"../FMOD BASIC/LandWallCling".play()
		elif x.get_normal() == Vector2(-1, 0):
			collision_mask = 0b0011 #turns one way collisions back on
			invincible = false #for dashing through enemies
			position += Vector2(-1,0) #prevents clipping
			state = "wall cling"
			jump_f = false
			clingfacing = -1
			velocity = Vector2(0,0)
			$wallcling_timer.start()
			$dash_timer.stop()
			$"../FMOD BASIC/LandWallCling".play()
		else:
			velocity = Vector2(0,0)




func player_wallcling():
	#wall release
	if Input.is_action_pressed("ui_down"):
		$floor_lockout.start() #prevents the player from regaining jump from touching ground bc godots floor detection near walls is glitchy
		state = "move" #end the wallcling
		$wallcling_timer.stop()
	#wall timeout
	elif $wallcling_timer.is_stopped():
		$floor_lockout.start() #prevents the player from regaining jump from touching ground bc godots floor detection near walls is glitchy
		state = "move"
	#walljump
	elif Input.is_action_just_pressed("ui_up"):
		$floor_lockout.start() #prevents the player from regaining jump from touching ground bc godots floor detection near walls is glitchy
		state = "move"
		velocity = Vector2(-0.5*clingfacing, sqrt(3)*0.5) * JUMP_VELOCITY * 1.2



func _on_dash_ready(dir: Variant) -> void:
	dash_f = true
	dash_dir = dir

func _on_dash_unready() -> void:
	dash_f = false

func _on_coyote_timeout() -> void:
	jump_f = false

func _on_dash_timer_timeout() -> void:
	collision_mask = 0b0011 #turns one way collisions back on
	invincible = false #for dashing through enemies
	state = "move"


func _on_area_2d_damage_death() -> void:
	state = "dead"
	if not triggered:
		triggered = true
		fade_out.emit()
		animated_sprite.play("DEATH")
		$"../Transition".play("FADEOUT")
		$"../FMOD BASIC/Die".play()
		$"../FMOD BASIC/DieMusic".play()
		$"../FMOD BASIC/Music".stop()
		$death_timer.start(4)
		
func _unhandled_key_input(event):
	if death_timer_triggered and state == "dead" and event.is_pressed():
			$"../FMOD BASIC/DieMusic".stop()
			get_tree().reload_current_scene()
		# do something...
	


func _on_death_timer_timeout() -> void:
	death_timer_triggered = true
