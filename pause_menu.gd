extends Control
func resume():
	get_tree().paused = false;
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true;
	$AnimationPlayer.play("blur")	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_reload_pressed() -> void:
	$AnimationPlayer.stop()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_music_button_toggled(toggled_on: bool) -> void:
	GlobalAudioSignals.toggle_bgm()
