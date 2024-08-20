extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var spots_left = 4
	for x in $"../../../Player".weak_spots_hit:
		if x:
			spots_left -= 1
	text = "Remaining weakpoints: " + str(spots_left)
