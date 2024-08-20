extends CharacterBody2D

@export var fire_breath_cooldown: float = 3.0
@export var projectile_scene: PackedScene
@export var projectiles_per_attack: int = 5
@export var spread_angle: float = 30.0  # Total spread angle in degrees

@onready var fire_breath_timer = $FireBreathTimer
@onready var source_pos = $source_pos
@onready var sprite = $head_sprite
@onready var breath_sound = $breath_sound
@onready var hurt_sound = $hurt_sound
@onready var roar = $roar
@onready var death_sound = $death_sound


@export var aggro_zone: Area2D
var detected_player = false

@export var player: Node2D
var rng = RandomNumberGenerator.new()

@export var heart: Node2D


var can_fire_breath = true

#for camera
@export var camera: Camera2D

func _ready():
	roar.play()
	fire_breath_timer.wait_time = fire_breath_cooldown
	fire_breath_timer.timeout.connect(_on_fire_breath_cooldown)
	

func _process(delta):
	if can_fire_breath and detected_player:
		fire_breath_attack()
	if(player.weak_spots_hit == [true, true, true, true]):
		heart.activate()

func fire_breath_attack():
	can_fire_breath = false
	fire_breath_timer.start()
	look_at(Vector2(player.global_position.x, player.global_position.y))
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
		get_parent().add_child(projectile)
		projectile.global_position = source_pos.global_position
		projectile.initialize(source_pos.global_position, target_pos)

		await get_tree().create_timer(0.1).timeout  # Small delay between projectiles

func _on_fire_breath_cooldown():
	can_fire_breath = true

func hurt():
	camera.shake(50)
	hurt_sound.play()

func die():
	camera.shake(80)
	death_sound.play()



func _on_fire_aggro_zone_area_entered(area:Area2D) -> void:
	if(area.get_name()=="Hurtbox"):
		detected_player = true



func _on_fire_aggro_zone_area_exited(area:Area2D) -> void:
	if(area.get_name()=="Hurtbox"):
		detected_player = false
