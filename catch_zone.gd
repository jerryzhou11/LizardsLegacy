extends Area2D

@export var Character: NodePath
@export var Spear: NodePath

const PICKUP_RANGE = 30

signal spear_caught

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$CollisionShape2D.radius = PICKUP_RANGE #idk how this works. 
	var player = get_node(Character)
	if not player:
		return
	var spear = get_node(Spear)
	if not spear:
		return
	pass # Replace with function body.

func _spear_catch(body) -> void:
	print(body.name)
	if body.name == "Spear":
		print("spear get")
		spear_caught.emit()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_node(Character)
	if not player:
		return
	global_position = player.global_position #makes sure the area is centered on the plaer
