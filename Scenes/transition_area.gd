extends Node2D

func _on_next_stage_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		get_tree().change_scene_to_file("res://Areas/game_scene.tscn")
