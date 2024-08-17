extends CharacterBody2D
var stomping : bool = true
var SPEED = 600
@onready var player := get_parent().get_node("Player")


@onready var collision_shape := $Hitbox

func _physics_process(delta: float) -> void:
	if(stomping and not is_on_floor()):
		stomp_move(delta)

func stomp_move(delta)->void:
	if player:
		velocity = global_position.direction_to(player.global_position)
		move_and_collide(velocity * SPEED * delta)


func set_disabled(is_disabled:bool)->void:
	collision_shape.set_deferred("disabled", is_disabled)