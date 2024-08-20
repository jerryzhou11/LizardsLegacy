extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var tail_timer = $Tail_Cooldown

@export var cooldown : float = 2.5

func _ready():
	tail_timer.timeout.connect(_on_Tail_Cooldown_timeout)

func _process(delta):
	if can_attack:
		start_tail_attack()	
	
var can_attack = true

func start_tail_attack() -> void:
	can_attack = false
	play_animation()


func _on_Tail_Cooldown_timeout():
	can_attack = true

func play_animation():
	animation_player.play("tail_swiping", .5)


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	tail_timer.wait_time = cooldown
	tail_timer.start()
