extends CheckButton


# Called when the node enters the scene tree for the first time.
func _toggled(toggled_on: bool) -> void:
	print("Fullscreen: ", toggled_on)
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
