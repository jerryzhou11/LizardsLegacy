extends Node


func hit_stop_short():
	print("hit stop")
	Engine.time_scale = 0.2
	await get_tree().create_timer(0.5, true, false, true).timeout
	Engine.time_scale = 1