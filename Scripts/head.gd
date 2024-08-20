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
	
	#fire projectiles towards player
	for i in range(projectiles_per_attack):
		var projectile = projectile_scene.instantiate()
		var target_pos = player.global_position
		target_pos.x += rng.randf_range(-spread_angle,spread_angle)
		target_pos.y += rng.randf_range(-spread_angle,spread_angle)

		projectile.initialize(source_pos.global_position, target_pos)
		get_tree().root.add_child(projectile)
		await get_tree().create_timer(0.2).timeout  # Small delay between projectiles

func _on_fire_breath_cooldown():
	can_fire_breath = true