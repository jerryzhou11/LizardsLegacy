extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $"../../../Player":
		if not $"../../../Player".items["armor"]:
			visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
