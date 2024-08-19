extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = 400.0
const DASH_SPEED = 1200.0
const VERTICAL_DASH_SPEED = 400.0
const VERTICAL_DASH_SPEED_FLIGHT = 1200.0
const DASH_LENGTH = .15
const DASH_COOLDOWN = .8
const FLIGHT_YACCEL = 800.0 #per second
const FLIGHT_MAX_STAMINA = 2.0 #seconds
const FLIGHT_STAMINA_RECOVERY = 0.2 # per second 
const GROUND_STAMINA_RECOVERY = 4.0 # per second
const FLIGHT_YSPEED = 500.0
const FLAP_YSPEED = 400.0
const FLAP_COOLDOWN = .8
const FLAP_STAMINA = 0.2 # seconds
const DASH_UP_STAMINA = 0.4 # seconds
const DEAD_DRAG = 0.05
var animation_locked : bool = false
var direction := 0
var facing = 1
var inv = []
var flight_stamina = 0.0
var dead = false
var flap_available = true
var flap_timer = 0.8
var armor_used = false
var dash_ground_reset = true

@export var debugMode = true
@export var play_bgm = false

@onready var dash = $Dash
@onready var lizamation = $lizamation

@onready var songplayer = $song_player # sound zone
@onready var hitplayer = $get_hit_player

func _ready():
	if(play_bgm):
		songplayer.play()
	
var items = {
	"armor": false,
	"wings": false,
	"spear_upgrade": false,
	
}

	
func get_staminabar_percent() -> float:
	return 100 * flight_stamina/FLIGHT_MAX_STAMINA

func can_fly() -> bool:
	if not items.wings:
		return false
	if flight_stamina < 0:
		return false
	return true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("print_inv"):	
		print("hi")
	if Input.is_action_just_pressed("debug_toggle_flight"):
		items.wings = not items.wings
		print("wings: ", items.wings)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		dash_ground_reset = true
		flap_available = true
		
	if dead:
		velocity.x = velocity.x * (1.0 - DEAD_DRAG) ** delta
		print(velocity)
		move_and_slide()
		return	
		
	flap_timer = move_toward(flap_timer, 0, delta)
	if flap_timer == 0:
		flap_available = true
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	elif Input.is_action_pressed("jump") and can_fly():
		if flap_available and abs(velocity.y - -FLIGHT_YSPEED) > 120: 
			print("flap!")
			flight_stamina -= FLAP_STAMINA
			flap_available = false
			flap_timer = FLAP_COOLDOWN
			velocity.y = move_toward(velocity.y, -FLIGHT_YSPEED, FLAP_YSPEED + get_gravity().y*delta)
		else:
			flight_stamina = flight_stamina - delta
			velocity.y = move_toward(velocity.y, -FLIGHT_YSPEED, (FLIGHT_YACCEL + get_gravity().y) * delta)
	elif is_on_floor(): 
		# recover flight stamina
		flight_stamina = move_toward(
			flight_stamina, 
			FLIGHT_MAX_STAMINA, 
			GROUND_STAMINA_RECOVERY*delta
		)
	else:
		flight_stamina = move_toward(
			flight_stamina, 
			FLIGHT_MAX_STAMINA, 
			FLIGHT_STAMINA_RECOVERY*delta
		)
	
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
	if (Input.is_action_just_pressed("dash") 
		and dash.finished_cooldown() 
		and (dash_ground_reset or items.wings)
	):
		dash_ground_reset = false
		dash.start_dash_duration(DASH_LENGTH)
		dash.start_cooldown(DASH_COOLDOWN)
		if y_direction < 0 and can_fly():
			var old_vy = velocity.y
			flight_stamina -= DASH_UP_STAMINA * (1200 + old_vy)/1200
	if dash.is_dashing():
		velocity.x = direction * DASH_SPEED
		if can_fly():
			velocity.y = y_direction * VERTICAL_DASH_SPEED_FLIGHT
		elif flight_stamina < 0 and items.wings:
			pass
		else:
			velocity.y = y_direction * VERTICAL_DASH_SPEED
				

		
	move_and_slide()
	update_animation()

#the only thing that can enter our hurtbox are enemy attacks.
func _on_hurtbox_area_entered(area:Node) -> void:
	print("You died!")
	#print(area)
	get_hit(area)
	#obviously, placeholder death condition.

func _on_hurtbox_body_entered(body) -> void:
	print(body.get_name())
	if body is RigidBody2D: #rock
		print("hit by rock lmao")
		get_hit(body)
	if body.get_name() == "Tail":
		get_hit(body)
		print("Hit by tail")

# Returns true if the hit killed the player, false otherwise
func get_hit(body) -> bool:
	hitplayer.play()
	HitstopManager.hit_stop_short()
	if inv.has("armor") and not armor_used:
		armor_used = true
		return false
	if not debugMode:
			dead = true
			ragdoll(body.linear_velocity, 2000)
	return true	

func ragdoll(direction: Vector2, force: float) -> void:
	velocity = direction.normalized() * force
	velocity.y = -abs(velocity.y)
	print(velocity)
	
func update_animation():
	if not animation_locked:
		if direction != 0:
			if dash.is_dashing():
				if (facing == 1):
					lizamation.play("dash_R", 8)
				else:
					lizamation.play("dash_L", 8)			
			else:
				if (facing == 1):
					lizamation.play("walk_R", 2)
				else:
					lizamation.play("walk_L", 2)
		else:
			if (facing == 1):
				lizamation.play("idle_R")
			else:
				lizamation.play("idle_L")
