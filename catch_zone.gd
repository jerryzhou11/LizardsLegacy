extends Area2D


const PICKUP_RANGE = 30

signal spear_caught

func _spear_catch(body) -> void:
	if body.name == "Spear":
		spear_caught.emit()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	#makes sure the area is centered on the plaer
