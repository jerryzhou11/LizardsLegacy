extends Node

signal bgm_toggle

func toggle_bgm():
	emit_signal("bgm_toggle")
