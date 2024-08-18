extends ProgressBar

@export var Character: NodePath
var attached_character
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attached_character = get_node(Character)
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attached_character:
		if attached_character.items.wings:
			show()
			value = attached_character.get_staminabar_percent()
		else:
			hide()
