class_name PlatformProto
extends CharacterBody2D

enum {
	NORMAL,
	DASH,
	WALL_CLING,
	WALL_JUMP,
}

@export var coyote_time : float = 0.2
@export var jump_buffer_time : float = 0.2
@export var jump_limit : int = 2 #if more that 1, allow jump while on air

@export var dash_time : float = 0.2
@export var dash_speed : float = 300.0
@export var wallcling_gravity : float = 1000.0
@export var walljump_time : float = 0.2

const SPEED = 200.0
const JUMP_VELOCITY = -320.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var state = NORMAL

var airborne : float = 0.0 
var jump_buffer : float = -1.0
var jump_count : int = 0

var dash_timer : float = 0.0
var walljump_timer: float = 0.0
var walljump_dir = 1

@onready var animation_player = $AnimationPlayer
@onready var _characterBody2D = $CharacterBody2D
@onready var ray_floor = $ray_floor
@onready var _animated_sprite = $BatSprite2D

func _physics_process(delta):
	match state:
		NORMAL:
			do_normal(delta)
		DASH:
			do_dash(delta)
		WALL_CLING:
			do_wall_cling(delta)
		WALL_JUMP:
			do_wall_jump(delta)
			
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
			
func do_normal(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		airborne += delta
		if jump_count == 0 and airborne > coyote_time:
			jump_count = 1
	else:
		airborne = 0.0
		jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") :
		jump_buffer = jump_buffer_time
		
	#if jump_buffer >= 0.0 and airborne < coyote_time and jump_count < jump_limit:
	if jump_buffer >= 0.0 and jump_count < jump_limit:
		velocity.y = JUMP_VELOCITY
		jump_buffer = -1.0
		jump_count += 1
	
	jump_buffer = clamp(jump_buffer - delta, -1.0, jump_buffer_time)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#ANIMATION AND SPRITE FACING
	if abs(velocity.x) < 0.1:
		play_idle()
	else:
		play_walk()
		if velocity.x > 0:
		
			_animated_sprite.scale.x = 1
		else:
			_animated_sprite.scale.x = -1
			
	if Input.is_action_just_pressed("dash"):
		dash_timer = 0.0
		state = DASH
		
	if is_on_wall_only() and not is_equal_approx(direction, 0.0):
		state = WALL_CLING
		
func do_dash(delta):
	var direction = 1.0
	if _animated_sprite.scale.x == -1 : 
		direction = -1.0
	velocity.x = direction * dash_speed
	velocity.y = 0.0
	move_and_slide()
	
	dash_timer += delta
	if dash_timer >= dash_time:
		state = NORMAL
		
	#OPTIONAL BEHAVIOR
	if not ray_floor.is_colliding() and jump_count == 0:
		jump_count = 1
	
	if Input.is_action_just_pressed("jump") :
		jump_buffer = jump_buffer_time
		state = NORMAL

func do_wall_cling(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction
	velocity.y = wallcling_gravity * delta
	move_and_slide()
	
	if is_equal_approx(direction, 0.0):
		state = NORMAL
		
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		jump_buffer = -1.0
		jump_count = 1
		state = WALL_JUMP
		walljump_dir = -1
		if _animated_sprite.scale.x == -1 :
			walljump_dir = 1
		walljump_timer = 0.0
	
func do_wall_jump(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		airborne += delta
		if jump_count == 0 and airborne > coyote_time:
			jump_count = 1
	else:
		airborne = 0.0
		jump_count = 0
		state = NORMAL

	# Handle jump.
	if Input.is_action_just_pressed("jump") :
		jump_buffer = jump_buffer_time
		
	#if jump_buffer >= 0.0 and airborne < coyote_time and jump_count < jump_limit:
	if jump_buffer >= 0.0 and jump_count < jump_limit:
		velocity.y = JUMP_VELOCITY
		jump_buffer = -1.0
		jump_count += 1
	
	jump_buffer = clamp(jump_buffer - delta, -1.0, jump_buffer_time)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	velocity.x = walljump_dir * SPEED
	
	move_and_slide()
	
	walljump_timer += delta
	if walljump_timer >= walljump_time:
		state = NORMAL
	
	#ANIMATION AND SPRITE FACING
	if abs(velocity.x) < 0.1:
		play_idle()
	else:
		play_walk()
		if velocity.x > 0:
			_animated_sprite.scale.x = -1
		else:
			_animated_sprite.scale.x = 1
			
func play_idle():
		_animated_sprite.play("IDLE")
		
func play_walk():
		_animated_sprite.play("IDLE")
	#if animation_player.current_animation != "WALK":
		#animation_player.play("WALK")
	
