#extends Node2D

#@onready var animation = $AnimationPlayer
#
#func _ready() -> void:
	#print("Wing node ready")
	#if animation:
		#print("AnimationPlayer found")
	#else:
		#print("AnimationPlayer not found")
	#flap()  # Start the flap animation
#
#func _process(delta: float) -> void:
	## We don't need to check or start the animation in _process anymore
	#pass
#
#func flap() -> void:
	## Play the flap animation
	#animation.play("flap")
	## Wait until the flap animation finishes
	#await animation.animation_finished
	## Play the flap animation in reverse
	#animation.play_backwards("flap")
	## Wait until the reverse animation finishes
	#await animation.animation_finished
	## Optionally, call flap() again to create a continuous loop
	## flap()
	
	
extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var is_reversing = false

func _ready():
	assert(animated_sprite != null, "AnimatedSprite2D child node not found")
	assert(animation_player != null, "AnimationPlayer child node not found")
	setup_animation()

func setup_animation():
	# Ensure the AnimatedSprite2D is set to the correct animation
	animated_sprite.animation = "wing_flap"
	#animated_sprite.frame = 0

	# Connect to the animation_finished signal of AnimationPlayer
	animation_player.animation_finished.connect(on_animation_finished)
	
	# Start the animation
	start_animation()

func start_animation():
	animation_player.play("flap")
	is_reversing = false

func stop_animation():
	animation_player.stop()

func on_animation_finished(anim_name):
	if anim_name == "flap":
		if is_reversing:
			animation_player.play("flap")
			is_reversing = false
		else:
			animation_player.play_backwards("flap")
			is_reversing = true

func _process(delta):
	# Update the AnimatedSprite2D frame based on the AnimationPlayer's progress
	var progress = animation_player.current_animation_position
	var frame_count = animated_sprite.sprite_frames.get_frame_count("wing_flap")
	if (-1.0 < progress and progress <= .25): 
		animated_sprite.frame = 0
	elif (.25 < progress and progress <= .5): 
		animated_sprite.frame = 1
	elif (.5 < progress and progress <= .75):
		animated_sprite.frame = 2
	else:
		animated_sprite.frame = 3
