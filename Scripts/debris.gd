extends RigidBody2D
@export var duration: float = 3.0
@export var impactStrength: float = 2.5

@onready var impact_sound = $impact_sound #sound
#for camera shake
var camera: Camera2D

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	contact_monitor = true
	max_contacts_reported = 1
	
func _on_body_entered(body:Node) -> void:
	if body.is_in_group("Stage"):
		camera.shake(impactStrength)
		impact_sound.play()
		await get_tree().create_timer(0.2).timeout
		queue_free()
