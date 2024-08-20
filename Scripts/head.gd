extends CharacterBody2D

@export var fire_breath_cooldown: float = 3.0
@export var projectile_scene: PackedScene
@export var projectiles_per_attack: int = 5
@export var spread_angle: float = 30.0  # Total spread angle in degrees

@onready var fire_breath_timer = $FireBreathTimer
@onready var source_pos = $source_pos
@onready var sprite = $head_sprite
@onready var breath_sound = $breath_sound
@export var player: Node2D
var rng = RandomNumberGenerator.new()


var can_fire_breath = true

#for camera
@export var camera: Camera2D

func _ready():
	fire_breath_timer.wait_time = fire_breath_cooldown
	fire_breath_timer.timeout.connect(_on_fire_breath_cooldown)

func _process(delta):
	if can_fire_breath and player:
		print("firing")
		fire_breath_attack()

func fire_breath_attack():
	can_fire_breath = false
	fire_breath_timer.start()
	look_at(player.global_position * -1)
	sprite.play()
	breath_sound.play()
	camera.shake(10)

	#fire projectiles towards player
	for i in range(projectiles_per_attack):
		var projectile = projectile_scene.instantiate()

		# Calculate spread in radians
		var spread_rad = deg_to_rad(spread_angle)

		# Calculate a random angle within the spread
		var random_angle = rng.randf_range(-spread_rad/2, spread_rad/2)

		# Get the direction to the player and rotate it by the random angle
		var direction = (player.global_position - source_pos.global_position).normalized()
		direction = direction.rotated(random_angle)

		# Calculate the target position
		var target_pos = source_pos.global_position + direction * 1000  # Arbitrary large distance

		# Add the projectile to the scene and initialize it
		get_tree().root.add_child(projectile)
		projectile.global_position = source_pos.global_position
		projectile.initialize(source_pos.global_position, target_pos)

		await get_tree().create_timer(0.1).timeout  # Small delay between projectiles

func _on_fire_breath_cooldown():
	can_fire_breath = true
