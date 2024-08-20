extends Node

signal transition_from_village_to_transition

func _on_transition_from_village_to_transition():
	get_tree().change_scene("res://Scenes/transition_area.tscn")
