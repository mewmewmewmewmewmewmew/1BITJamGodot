extends CharacterBody2D

@export var ACCEL = 10
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -300.0
var jump_f := false #jump flag, allows the player to jump
var state = "move"

func _physics_process(delta: float) -> void:
	if state == "move":
		player_move(delta)

func player_move(delta):
	if is_on_floor():
		jump_f = true
		$coyote_timer.stop()
	# Add the gravity.
	else:
		velocity += get_gravity() * delta
		if $coyote_timer.is_stopped() == true and jump_f == true:
			$coyote_timer.start() #the timer event is at the bottom of this script

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jump_f == true:
		velocity.y = JUMP_VELOCITY
		jump_f = false
		$coyote_timer.stop()

	#handles horizontal movement
	if Input.is_action_pressed("ui_left") != Input.is_action_pressed("ui_right"): #make sure only left xor right is pressed
		if Input.is_action_pressed("ui_left"):
			if velocity.x > 0:
				velocity.x -= ACCEL*2 #double ACCEL for reverse movement
			else:
				velocity.x -= ACCEL
		else: #this is pressing right
			if velocity.x < 0:
				velocity.x += ACCEL*2 #double ACCEL for reverse movement
			else:
				velocity.x += ACCEL
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
	#enforces speed limit
	if velocity.x > SPEED:
		velocity.x = SPEED
	if velocity.x < -SPEED:
		velocity.x = -SPEED

	move_and_slide()

func _on_coyote_timeout() -> void:
	jump_f = false
