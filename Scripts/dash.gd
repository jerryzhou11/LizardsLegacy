extends Node2D

@onready var cooldown_timer = $cooldowntimer
@onready var dash_timer = $dashtimer

func start_dash_duration(dur: float) -> void:
	dash_timer.wait_time = dur
	dash_timer.start()
	
func is_dashing() -> bool:
	return not dash_timer.is_stopped()

func start_cooldown(dur: float) -> void:
	cooldown_timer.wait_time = dur
	cooldown_timer.start()
	
func finished_cooldown() -> bool:
	return cooldown_timer.is_stopped()
