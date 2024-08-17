extends CharacterBody2D


const THROW_SPEED = 900.0
const MAX_RECALL_SPEED = 5000.0
const MIN_RECALL_SPEED = 300.0
const RECALL_ACCEL = 3000.0 # per second
const PICKUP_RANGE = 50.0   
const AIR_RESISTANCE = 0
const VELOCITY_INHERETANCE = 1 #percent of player velocity that adds to throw

@export var Character: NodePath
@export var CatchZone: NodePath
@onready var Collider := $CollisionShape2D


enum SpearState {
	CARRIED,
	THROWN,
	STUCK, 
	RECALL
}
var state = SpearState.CARRIED
	
func _physics_process(delta: float) -> void:
	#collision was pushing around player when spear was held. 
	if state == SpearState.RECALL or state == SpearState.CARRIED:
		set_collision_mask_value(1, false) 
		# instead of global collision turnoff, 
		# just turning off collision with the world
	else:
		set_collision_mask_value(1, true) 
	
	match state:
		SpearState.THROWN:
			if is_on_floor():
				state = SpearState.STUCK
				return
			velocity += get_gravity() * delta
			velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * velocity.x)
			rotation = velocity.angle()
			move_and_slide()
		SpearState.CARRIED:
			look_at(get_global_mouse_position())
			var carrier = get_node(Character)
			if not carrier:
				print("no carrier")
				return
			global_position = carrier.global_position + Vector2(16, -16)
		SpearState.STUCK:
			pass
		SpearState.RECALL:
			var carrier = get_node(Character)
			if not carrier:
				return
			var vector_to_player = carrier.global_position - global_position
			rotation = PI + vector_to_player.angle() # face away from the player
			velocity = vector_to_player.normalized() * clampf(
				(RECALL_ACCEL * delta) + velocity.length(), 
				MIN_RECALL_SPEED, 
				MAX_RECALL_SPEED
			)			
			move_and_slide()
			#if vector_to_player.length() < PICKUP_RANGE: # this is evil. TODO fix
				#state = SpearState.CARRIED
				
			
				
						

func _input(event) -> void:
	if event.is_action_pressed("throw"):
		match state:
			SpearState.CARRIED:
				velocity = THROW_SPEED * Vector2.RIGHT.rotated(rotation)
				var carrier = get_node(Character)
				if not carrier:
					return
				velocity += carrier.velocity * VELOCITY_INHERETANCE
				state = SpearState.THROWN
			_:
				state = SpearState.RECALL

func _ready() -> void:
	pass

func _on_catch_zone_spear_caught() -> void:
	print("signal caught")
	if state == SpearState.RECALL:
		state = SpearState.CARRIED
		
