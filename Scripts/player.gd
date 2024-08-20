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
const DEAD_DRAG = 800
var animation_locked : bool = false
var direction := 0
var facing = 1
var flight_stamina = 0.0
var dead = false
var flap_available = true
var flap_timer = 0.8
var armor_used = false
var dash_ground_reset = true
var in_wind_zone = false
var iframes = false
var burnt = false

@export var debugMode = true
# @export var play_bgm = true

#wind
@export var wind_force = 20000
@export var wind_slow = 50

@export var scales = 0 # how much money you have

#camera
@export var camera: Camera2D

@onready var dash = $Dash
@onready var lizamation = $lizamation

@onready var bossBGM = $song_player # sound zone
@onready var villageBGM = $village_player
@onready var hitplayer = $get_hit_player
@onready var deathplayer = $death_player
@onready var flap_sfx_player = $wing_flap_player
@onready var clink_player = $clink_player

func _ready():
	GlobalAudioSignals.connect("bgm_toggle", Callable(self, "_on_bgm_toggle"))
	
	ShopSignals.connect("item_1", Callable(self, "buy_item_1"))
	ShopSignals.connect("item_2", Callable(self, "buy_item_2"))
	ShopSignals.connect("item_3", Callable(self, "buy_item_3"))
	ShopSignals.connect("item_4", Callable(self, "buy_item_4"))
	ShopSignals.connect("item_5", Callable(self, "buy_item_5"))
	
	bossBGM.volume_db = -8
	bossBGM.play()
	
var items = {
	"armor": true,
	"spear_upgrade": false,
	"grapple": false,
	"item4": false,
	"wings": true
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
	if in_wind_zone and not dead:
		velocity.x += wind_force * delta
		move_and_slide()
		
	if dead:
		velocity.x = move_toward(velocity.x, 0, delta * DEAD_DRAG)
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
			flap_sfx_player.play()
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
		velocity.x = (direction * SPEED)
		if in_wind_zone:
			velocity.x += wind_slow
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

func _on_hurtbox_area_entered(area:Node) -> void:
	if(area.is_in_group("Hazards")):
		if(area.is_in_group("Fire")):
			camera.shake(15)
			burnt = true
		get_hit(area)
	elif(area.get_name() == "WindZone"):
		if(area.get_meta("is_active")):
			print("entered wind")
			in_wind_zone = true

func _on_hurtbox_area_exited(area:Area2D) -> void:
	if(area.get_name() == "WindZone"):
		print("exited wind")
		in_wind_zone = false

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
	if items["armor"] and not armor_used and not burnt:
		clink_player.play()
		armor_used = true
		iframes = true
		await get_tree().create_timer(0.5).timeout 
		iframes = false
		return false
	if not dead and not iframes:
		hitplayer.play()
		if(facing==1):
			lizamation.play("get_hit")
		else:
			lizamation.flip_h = true
			lizamation.play("get_hit")
		HitstopManager.hit_stop_short()
	if not debugMode and not dead and not iframes:
		dead = true
		bossBGM.stop()
		var ragdoll_dir: Vector2
		if body and "linear_velocity" in body:
			ragdoll_dir = body.linear_velocity
		else:
			if(facing==1):
				ragdoll_dir = Vector2(-1, -1)
			else:
				ragdoll_dir = Vector2(1, -1)
		await get_tree().create_timer(0.5).timeout 
		deathplayer.play()
		if burnt:
			if(facing==1):
				lizamation.play("death_fire")
			else:
				lizamation.flip_h = true
				lizamation.play("death_fire")
		else:
			if(facing==1):
				lizamation.play("death_reg")
			else:
				lizamation.flip_h = true
				lizamation.play("death_reg")
			ragdoll(ragdoll_dir, 800) #commented out because was causing crashes
	return true	

func ragdoll(direction: Vector2, force: float) -> void:
	if direction.length() < 0.01:
		direction = Vector2(-1, -1)
	velocity = direction.normalized() * force
	velocity.y = -abs(velocity.y)
	#print(velocity)
	
func update_animation():
	if not animation_locked:
		if items.wings and (direction != 0 or not is_on_floor()):
				if (facing == 1):
					lizamation.play("fly_R")
				else:
					lizamation.play("fly_L")
		if items.wings:
			if direction != 0:	
				if dash.is_dashing():
					if (facing == 1):
						#lizamation.play("wing_dash_R", 8)
						lizamation.play("dash_R", 8)
					else:
						#lizamation.play("wing_dash_L", 8)	
						lizamation.play("dash_L", 8)			
				else:
					if (facing == 1):
						print("wingwalk")
						lizamation.play("wing_walk_R", 2)
					else:
						print("wingwalk2")
						lizamation.play("wing_walk_L", 2)
			else:
				if (facing == 1):
					lizamation.play("wing_idle_R")
				else:
					lizamation.play("wing_idle_L")
		elif direction != 0:	
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

func _on_bgm_toggle():
	var volume = bossBGM.volume_db
	if volume > -79:
		volume = -80
	else:
		volume = -8
	bossBGM.volume_db = volume
	villageBGM.volume_db = volume
 	# print("audio print notif")

func buy_item_1():
	print("bought item 1")
	items["armor"] = true

func buy_item_2():
	print("bought item 2")
	items["spear_upgrade"] = true
	
func buy_item_3():
	print("bought item 3")
	items["grapple"] = true
	
func buy_item_4():
	print("bought item 4")
	items["item4"] = true
	
func buy_item_5():
	print("bought item 5")
	items["wings"] = true

func _on_village_ready() -> void:
	bossBGM.stop()
	villageBGM.play()



func _on_game_scene_ready() -> void:
	villageBGM.stop()
	bossBGM.play()
