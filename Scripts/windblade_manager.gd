extends Node2D

@export var projectile_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var spawn_y_min: float = 100.0
@export var spawn_y_max: float = 500.0

@onready var timer = $spawn_timer
@export var wind_noise: AudioStreamPlayer2D

var active = true

func _ready() -> void:
	timer.wait_time = spawn_interval

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	var spawn_position = Vector2(0, randf_range(spawn_y_min, spawn_y_max))
	projectile.position = spawn_position
	add_child(projectile)

func _on_spawn_timer_timeout() -> void:
	#print("wind blade fired")
	spawn_projectile()

func _on_wind_zone_body_entered(body:Node2D) -> void:
	if(body.get_name()=="Player"):
		#print("wind blades start")
		if active:
			timer.start()

func _on_wind_zone_body_exited(body:Node2D) -> void:
	if(body.get_name()=="Player"):
		timer.stop()
