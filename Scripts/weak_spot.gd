extends Node2D

@onready var hit_sound = $HitSound
@onready var sprite = $Sprite2D
var vanquished = false
@export var weak_spot_number: int
@export var player: Node2D
@export var dragon: Node2D

func _ready() -> void:
	update_state()

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.Character:
		if not vanquished: 
			hit_sound.play()
			vanquished = true
			player.weak_spots_hit[weak_spot_number] = true
			PlayerData.save_player_state(player)
			sprite.play("inactive")
			dragon.hurt()
			
func update_state():
	if(player.weak_spots_hit[weak_spot_number]):
		vanquished = true
		sprite.play("inactive")
	else:
		sprite.play("active")