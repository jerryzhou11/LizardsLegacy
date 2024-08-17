extends Node2D

@export var foot_node: Node2D
@export var player_node: Node2D
@export var raise_height: float = 200.0
@export var raise_duration: float = 1.5
@export var smash_duration: float = 1
@export var cooldown_duration: float = 2.0

var original_position: Vector2
var is_attacking: bool = false

func _ready():
    original_position = foot_node.position

func start_stomp_attack():
    if not is_attacking:
        is_attacking = true
        var tween = create_tween()
        
        # Raise the foot slowly
        tween.tween_property(foot_node, "position:y", original_position.y - raise_height, raise_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
        
        # Wait for the raise to complete
        await tween.finished
        
        # Calculate target position (player's x, original y)
        var target_position = Vector2(player_node.global_position.x, player_node.global_position.y)
        
        # Smash down quickly towards the player's x-position, but only to ground level
        tween = create_tween()
        tween.tween_property(foot_node, "global_position", target_position, smash_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
        
        # Wait for the smash to complete
        await tween.finished
        
        # Short pause at the bottom
        await get_tree().create_timer(0.2).timeout
        
        # Return to original position
        tween = create_tween()
        tween.tween_property(foot_node, "position", original_position, cooldown_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
        
        # Wait for the return to complete
        await tween.finished
        
        is_attacking = false

func _physics_process(_delta):
    if Input.is_action_just_pressed("trigger_stomp"):
        start_stomp_attack()