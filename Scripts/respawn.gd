extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("respawn", 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_animated_sprite_2d_animation_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/village.tscn")
