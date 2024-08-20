extends Area2D

@export var speed: float = 400.0
@onready var animated_sprite = $AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	global_position += direction * speed * delta
	animated_sprite.play("flicker")

func initialize(start_pos: Vector2, target_pos: Vector2):
	global_position = start_pos
	direction = (target_pos - start_pos).normalized()
	rotation = direction.angle()

func _on_lifetime_timeout() -> void:
	queue_free()
