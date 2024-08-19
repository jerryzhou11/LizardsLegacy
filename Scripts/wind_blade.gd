extends Area2D

@export var speed: float = 300.0

func _physics_process(delta: float) -> void:
	position.x += speed * delta



func _on_lifetime_timeout() -> void:
	queue_free()


func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("dragon"):
		queue_free()
