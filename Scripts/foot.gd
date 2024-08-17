extends CharacterBody2D
var stomping : bool = true
var acc : = 2000
var target 

@onready var collision_shape := $CollisionShape2D

func _physics_process(delta: float) -> void:
	if(stomping and not is_on_floor()):
		stomp_move(delta)

func stomp_move(delta)->void:
	velocity.y += acc * delta
	move_and_slide()


func set_disabled(is_disabled:bool)->void:
	collision_shape.set_deferred("disabled", is_disabled)