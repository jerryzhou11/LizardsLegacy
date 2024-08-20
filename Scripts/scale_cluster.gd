extends Node2D

@export var scale_type : ScaleType = ScaleType.FOOT
@onready var particle_emitter = $GPUParticles2D
var harvested = false

enum ScaleType {
	FOOT,
	WING,
	TAIL
}

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not harvested:
		particle_emitter.restart()
		if body.Character:
			print(body.Character)
			var player = body.get_node(body.Character)
			player.scales += 1
			print(player.scales)
			harvested = true
