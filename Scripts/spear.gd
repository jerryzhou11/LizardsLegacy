extends CharacterBody2D


const THROW_SPEED = 500.0
const MAX_RECALL_SPEED = 10000.0
const MIN_RECALL_SPEED = 100.0
const RECALL_ACCEL = 50.0
const PICKUP_RANGE = 50.0   
const AIR_RESISTANCE = 0
const VELOCITY_INHERETANCE = 0.5 #percent of player velocity that adds to throw

@export var Character: NodePath
@onready var Collider := $CollisionShape2D

enum SpearState {
	CARRIED,
	THROWN,
	STUCK, 
	RECALL
}
var state = SpearState.CARRIED
	
func _physics_process(delta: float) -> void:
	if state == SpearState.RECALL:
		Collider.disabled = true
	else:
		Collider.disabled = false
	
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
				return
			global_position = carrier.global_position + Vector2(16, -16)
		SpearState.STUCK:
			pass
		SpearState.RECALL:
			var carrier = get_node(Character)
			if not carrier:
				return
			var vector_to_player = global_position - carrier.global_position
			var normal_to_player = vector_to_player.rotated(PI/2)
			rotation = vector_to_player.angle()
			
			#this is. A mess.
			velocity += -RECALL_ACCEL * vector_to_player.normalized() 
			# speed caps
			if velocity.length() < MIN_RECALL_SPEED:
				velocity = -MIN_RECALL_SPEED * vector_to_player.normalized() 
			elif velocity.length() > MAX_RECALL_SPEED:
				velocity = -MAX_RECALL_SPEED * vector_to_player.normalized() 
			#temporary fix to orbits: if you move towards the spear it locks onto you better
			velocity += -carrier.velocity * delta
			
			if vector_to_player.length() < PICKUP_RANGE: # this is evil. TODO fix
				state = SpearState.CARRIED
			move_and_slide()
				
						

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
	
