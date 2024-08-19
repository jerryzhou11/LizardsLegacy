extends Node2D
var is_item_in_store : Array = [true,true,true,true,true]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$shop_ui.hide()	
	hide_buttons()
	
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
		show_buttons()
	
#exit shop	
func _on_shop_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$shop_ui.hide()
		hide_buttons()
		
func show_buttons(): # shows the buttons i think
	if is_item_in_store[0] == true:
		$item_1.show()
	if is_item_in_store[1] == true:
		$item_2.show()
	if is_item_in_store[2] == true:
		$item_3.show()
	if is_item_in_store[3] == true:
		$item_4.show()
	if is_item_in_store[4] == true:
		$item_5.show()

func hide_buttons(): # hides the buttons
	$item_1.hide()
	$item_2.hide()
	$item_3.hide()
	$item_4.hide()
	$item_5.hide()

func _on_item_1_button_down() -> void:
	ShopSignals.purchase_1()
	is_item_in_store[0] = false
	$item_1.hide()

func _on_item_2_button_down() -> void:
	ShopSignals.purchase_2()
	is_item_in_store[1] = false
	$item_2.hide()
	
func _on_item_3_button_down() -> void:
	ShopSignals.purchase_3()
	is_item_in_store[2] = false
	$item_3.hide()
	
func _on_item_4_button_down() -> void:
	ShopSignals.purchase_4()
	is_item_in_store[3] = false
	$item_4.hide()

func _on_item_5_button_down() -> void:
	ShopSignals.purchase_5()
	is_item_in_store[4] = false
	$item_5.hide()
