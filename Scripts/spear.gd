extends CharacterBody2D


const THROW_SPEED = 500.0
const RECALL_SPEED = 1000.0
const AIR_RESISTANCE = 0

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
			rotation = vector_to_player.angle()
			velocity = vector_to_player.normalized() * -RECALL_SPEED
			if vector_to_player.length() < 16: 
				state = SpearState.CARRIED
			move_and_slide()
				
						

func _input(event) -> void:
	if event.is_action_pressed("throw"):
		match state:
			SpearState.CARRIED:
				velocity = THROW_SPEED * Vector2.RIGHT.rotated(rotation)
				state = SpearState.THROWN
			_:
				state = SpearState.RECALL
	
