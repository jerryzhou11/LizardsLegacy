extends CharacterBody2D

@export var fire_breath_cooldown: float = 3.0
@export var projectile_scene: PackedScene
@export var projectiles_per_attack: int = 5
@export var spread_angle: float = 30.0  # Total spread angle in degrees

@onready var fire_breath_timer = $FireBreathTimer
@onready var source_pos = $source_pos
@export var player: Node2D


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

	#fire projectiles towards player
	for i in range(projectiles_per_attack):
		var projectile = projectile_scene.instantiate()
		var target_pos = player.global_position

		projectile.initialize(source_pos.position, target_pos)
		get_parent().add_child(projectile)
		await get_tree().create_timer(0.1).timeout  # Small delay between projectiles

func _on_fire_breath_cooldown():
	can_fire_breath = true