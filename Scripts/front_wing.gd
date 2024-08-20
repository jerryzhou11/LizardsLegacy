extends Sprite2D

@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animation.play("flap")
	animation.play_backwards("flap")
	
func flap() -> void:
	animation.play("flap")
	animation.play_backwards("flap")
	
