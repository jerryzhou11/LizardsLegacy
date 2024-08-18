extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0
const DASH_SPEED = 1200.0
const VERTICAL_DASH_SPEED = 400.0
const VERTICAL_DASH_SPEED_FLIGHT = 1200.0
const FLIGHT_YACCEL = 800.0 #per second
const FLAP_YSPEED = 400.0
const FLIGHT_YSPEED = 500.0
const DASH_LENGTH = .15
const DASH_COOLDOWN = .8
const FLAP_COOLDOWN = .8
var animation_locked : bool = false
var direction := 0
var facing = 1
var inv = []

var can_fly := false
var flap_available = true
var flap_timer = 0.8

@onready var dash = $Dash
@onready var lizamation = $lizamation

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("print_inv"):	
		print("hi")
	if Input.is_action_just_pressed("debug_toggle_flight"):
		can_fly = not can_fly
		print("can_fly: ", can_fly)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		flap_available = true
	flap_timer = move_toward(flap_timer, 0, delta)
	if flap_timer == 0:
		flap_available = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	elif Input.is_action_pressed("jump") and can_fly:
		if flap_available and abs(velocity.y - -FLIGHT_YSPEED) > 120: 
			print("flap!")
			flap_available = false
			flap_timer = FLAP_COOLDOWN
			velocity.y = move_toward(velocity.y, -FLIGHT_YSPEED, FLAP_YSPEED + get_gravity().y*delta)
		else:
			velocity.y = move_toward(velocity.y, -FLIGHT_YSPEED, (FLIGHT_YACCEL + get_gravity().y) * delta)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")
	var y_direction = Input.get_axis("air_up", "air_down")
	if direction:
		velocity.x = direction * SPEED
		facing = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.x = direction * SPEED
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and dash.finished_cooldown():
		dash.start_dash_duration(DASH_LENGTH)
		dash.start_cooldown(DASH_COOLDOWN)
	if dash.is_dashing():
		velocity.x = direction * DASH_SPEED	
		if can_fly:
			velocity.y = y_direction * VERTICAL_DASH_SPEED_FLIGHT
		else:
			velocity.y = y_direction * VERTICAL_DASH_SPEED

		
	move_and_slide()
	update_animation()

#the only thing that can enter our hurtbox are enemy attacks.
func _on_hurtbox_area_entered(area:Area2D) -> void:
	print("You died!")
	#obviously, placeholder death condition.

func _on_hurtbox_body_entered(body:Node2D) -> void:
	print("You died!")
	
func update_animation():
	if not animation_locked:
		if direction != 0:
			if (facing == 1):
				lizamation.play("walk_R", 2)
			else:
				lizamation.play("walk_L", 2)
		else:
			if (facing == 1):
				lizamation.play("idle_R")
			else:
				lizamation.play("idle_L")
