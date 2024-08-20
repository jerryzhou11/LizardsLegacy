extends Node2D


@onready var sound = $flap

func _on_timer_timeout() -> void:
	sound.play()
