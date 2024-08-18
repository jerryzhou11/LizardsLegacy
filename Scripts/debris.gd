extends RigidBody2D
@export var duration: float = 3.0

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	contact_monitor = true
	max_contacts_reported = 1
	
func _on_body_entered(body:Node) -> void:
	if body is StaticBody2D:
		queue_free()
