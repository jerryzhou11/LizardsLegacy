extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$shop_ui.hide()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# right side area
func _on_next_stage_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		print("next stage entered")

#enter shop
func _on_shop_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$shop_ui.show()
	
#exit shop	
func _on_shop_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$shop_ui.hide()
		
