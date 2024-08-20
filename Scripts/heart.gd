extends Node2D

@onready var hit_sound_1 = $HitSound1
@onready var hit_sound_2 = $HitSound2
@onready var hit_sound_3 = $HitSound3
@onready var sprite = $Sprite2D
var health = 3
@export var dragon: Node2D

var active = false

func _ready():
	visible = false


func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.Character:
		if health ==3:
			health-=1
			sprite.play("hit")
			hit_sound_1.play()
			dragon.hurt()
		elif health ==2:
			health-=1
			sprite.play("critical")
			hit_sound_2.play()
			dragon.hurt()
		else:
			hit_sound_3.play()
			#dragon.die() big death sound
			#play win cutscene

func activate():
	visible = true
	active = true
