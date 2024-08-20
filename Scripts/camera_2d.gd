extends Camera2D

#screen_shake
@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var initial_offset: Vector2

func _ready() -> void:
	initial_offset = offset
	
func apply_shake():
	shake_strength = randomStrength

func shake(strength):
	shake_strength = strength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength)+initial_offset.x,rng.randf_range(-shake_strength,shake_strength)+initial_offset.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()
