extends Node2D

#for the actual stomp physics
@export var foot_node: Node2D
@export var player_node: Node2D
@export var raise_height: float = 200.0
@export var raise_duration: float = 1.5
@export var smash_duration: float = 1
@export var cooldown_duration: float = 2.0
@export var return_duration: float = 1.5
@export var arc_height: float = 100.0  # Maximum height of the arc
@export var max_horizontal_distance: float = 200.0
var original_position: Vector2
var return_start_position: Vector2
var is_attacking: bool = false
var original_y: float

@export var camera: Camera2D

#for the debris
@export var debris_count: int = 10
@export var debris_scene: PackedScene  # You'll need to create a debris scene with RigidBody2D
@export var debris_spread: float = 100.0  # How wide the debris spreads
@export var debris_force: float = 1000.0  # Force applied to debris


func _ready():
	original_position = foot_node.position
	original_y = foot_node.global_position.y

func start_stomp_attack():
	if not is_attacking:
		is_attacking = true
		var tween = create_tween()

		# Raise the foot slowly
		tween.tween_property(foot_node, "position:y", original_position.y - raise_height, raise_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		# Wait for the raise to complete
		await tween.finished
		
		# Calculate target position (player's x, original y). If player is too far away,
		# we will just stomp a set distance
		var target_position = Vector2(player_node.global_position.x, original_y)
		if(abs(target_position.x - foot_node.global_position.x) > max_horizontal_distance):
			if(target_position.x > foot_node.global_position.x):
				target_position.x = foot_node.global_position.x + max_horizontal_distance
			else:
				target_position.x = foot_node.global_position.x - max_horizontal_distance
	
		# Smash down quickly towards the player's x-position, but only to ground level
		tween = create_tween()
		tween.tween_property(foot_node, "global_position", target_position, smash_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

		# Wait for the smash to complete
		await tween.finished
		camera.apply_shake()

		# Spawn debris
		spawn_debris(target_position)
		

		# Short pause at the bottom
		await get_tree().create_timer(0.2).timeout


		return_start_position = foot_node.position


		# Return to original position with arc motion
		tween = create_tween()
		tween.tween_method(arc_motion, 0.0, 1.0, return_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		# Wait for the return to complete
		await tween.finished
		
		is_attacking = false

func arc_motion(progress: float):
	var start = return_start_position
	var end = original_position
	var mid = (start + end) / 2
	mid.y -= arc_height

	var p1 = start.lerp(mid, progress)
	var p2 = mid.lerp(end, progress)
	var arc_position = p1.lerp(p2, progress)

	foot_node.position = arc_position

func spawn_debris(spawn_position: Vector2):
	for i in range(debris_count):
		var debris = debris_scene.instantiate()
		add_child(debris)
		debris.global_position = spawn_position
        
        # Calculate random trajectory
		var angle = randf_range(PI/4,3*PI/4)  # Spread debris in a 90-degree arc
		var direction = Vector2(-cos(angle), -sin(angle))  # Negative sin for upward direction
        
        # Apply impulse to debris
		debris.apply_central_impulse(direction * debris_force)
        
        # Set up timer to destroy debris after 5 seconds
		var timer = Timer.new()
		timer.set_wait_time(debris.duration)
		timer.set_one_shot(true)
		timer.connect("timeout", Callable(debris, "queue_free"))
		add_child(timer)
		timer.start()


func _physics_process(_delta):
	if Input.is_action_just_pressed("trigger_stomp"):
		start_stomp_attack()
