#extends CharacterBody2D
#
#@onready var collision_polygon = $CollisionPolygon2D
#@onready var animation_player = $AnimationPlayer
#@onready var tail_timer = $Tail_Cooldown
#
#func _process(delta: float) -> void:
	#if is_not_on_cooldown():
		#play_animation()
		#start_tail_attack(7)
	#
#func start_tail_attack(dur: float) -> void:
	#tail_timer.wait_time = dur
	#tail_timer.start()
#
#func is_not_on_cooldown() -> bool:
	#return tail_timer.is_stopped()
	#
#func play_animation():
	#animation_player.play("tail_swiping")
	
extends CharacterBody2D

@onready var collision_polygon = $CollisionPolygon2D
@onready var animation_player = $AnimationPlayer
@onready var tail_timer = $Tail_Cooldown

var can_attack = true

func _process(delta: float) -> void:
	if can_attack:
		play_animation()
		start_tail_attack(7)

func start_tail_attack(dur: float) -> void:
	can_attack = false
	tail_timer.wait_time = dur
	tail_timer.start()

func _on_Tail_Cooldown_timeout():
	can_attack = true

func play_animation():
	animation_player.play("tail_swiping")

func _ready():
	tail_timer.timeout.connect(_on_Tail_Cooldown_timeout)
