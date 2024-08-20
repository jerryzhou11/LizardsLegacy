extends Area2D

@export var speed: float = 400.0

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	global_position += direction * speed * delta

func initialize(start_pos: Vector2, target_pos: Vector2):
	global_position = start_pos
	direction = (target_pos - start_pos).normalized()
	rotation = direction.angle()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
