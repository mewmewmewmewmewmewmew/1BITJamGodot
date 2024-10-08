extends CharacterBody2D

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


func _physics_process(delta: float) -> void:
	if state == "move":
		#handles dash
		if Input.is_action_just_pressed("ui_dash") and dash_f == true:
			$dash_timer.start() #ends the dash after a certain amount of time
			velocity = DASH_SPEED * dash_dir
			state = "dash"
		else:
			player_move(delta)
	if state == "dash":
		player_dash(delta)
	if state == "wall cling":
		player_wallcling()

func player_move(delta):
	if is_on_floor() and $floor_lockout.is_stopped():
		print
		jump_f = true
		$coyote_timer.stop()
	# Add the gravity.
	else:
		velocity += get_gravity() * delta
		if $coyote_timer.is_stopped() == true and jump_f == true:
			$coyote_timer.start() #the timer event is at the bottom of this script

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and jump_f == true:
		velocity.y = JUMP_VELOCITY
		jump_f = false
		$coyote_timer.stop()

	#handles horizontal movement
	if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"): #make sure only left xor right is pressed
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
		if x.get_normal() == Vector2(1, 0) and Input.is_action_pressed("ui_left"): #if colliding with a right facing wall while holding left
			position += Vector2(1,0) #prevents clipping
			state = "wall cling"
			jump_f = false
			clingfacing = 1
			velocity = Vector2(0,0)
			$wallcling_timer.start()
			$dash_timer.stop()
		elif x.get_normal() == Vector2(-1, 0) and Input.is_action_pressed("ui_right"):
			position += Vector2(-1,0) #prevents clipping
			state = "wall cling"
			jump_f = false
			clingfacing = -1
			velocity = Vector2(0,0)
			$wallcling_timer.start()
			$dash_timer.stop()
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
		velocity = Vector2(-sqrt(0.5)*clingfacing, sqrt(0.5)) * JUMP_VELOCITY * 1.15
		print(velocity)



func _on_dash_ready(dir: Variant) -> void:
	dash_f = true
	dash_dir = dir

func _on_dash_unready() -> void:
	dash_f = false

func _on_coyote_timeout() -> void:
	jump_f = false

func _on_dash_timer_timeout() -> void:
	state = "move"