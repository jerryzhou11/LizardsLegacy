extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1200
const DASH_LENGTH = .15
const DASH_COOLDOWN = .8

var inv = []

@onready var dash = $Dash

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("print_inv"):	
		print("hi")
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.x = direction * SPEED
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and dash.finished_cooldown():
		dash.start_dash_duration(DASH_LENGTH)
		dash.start_cooldown(DASH_COOLDOWN)
	if dash.is_dashing():
		velocity.x = direction * DASH_SPEED
		
	move_and_slide()

#the only thing that can enter our hurtbox are enemy attacks.
func _on_hurtbox_area_entered(area:Area2D) -> void:
	print("You died!")
