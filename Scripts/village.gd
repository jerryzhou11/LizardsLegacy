extends Node2D

var is_item_in_store : Array = [true,true,true,true,true]

#dont touch this it made me want to kill myself
@export var price1 = 0
@export var price2 = 1
@export var price3 = 0
@export var price4 = 5
@export var price5 = 5

@onready var prices_node = get_node("prices")
var money = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$shop_ui.hide()	
	hide_buttons()
	prices_node.hide()
	
	prices_node.get_node("item1label").text = str(price1)
	prices_node.get_node("item2label").text = str(price2)
	prices_node.get_node("item3label").text = str(price3)
	prices_node.get_node("item4label").text = str(price4)
	prices_node.get_node("item5label").text = str(price5)
	
	
	var player_node = $Player
	money = player_node.scales 
	
func _process(delta: float) -> void:
	pass

# right side area
func _on_next_stage_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		#print("next stage entered")
		get_tree().change_scene_to_file("res://Scenes/transition_area.tscn")

#enter shop
func _on_shop_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		$shop_ui.show()
		show_buttons()
		prices_node.show()
#exit shop	
func _on_shop_body_exited(body: Node2D) -> void:
	if body.get_name() == "Player":
		$shop_ui.hide()
		hide_buttons()
		prices_node.hide()
		
func show_buttons(): # shows the buttons i think
	var player = $Player
	if is_item_in_store[0] == true and not player.items["armor"]:
		$item_1.show()
	if is_item_in_store[1] == true and not player.items["spear_upgrade"]:
		$item_2.show()
	if is_item_in_store[2] == true and not player.items["grapple"]:
		$item_3.show()
	if is_item_in_store[3] == true and not player.items["item4"]:
		$item_4.show()
	if is_item_in_store[4] == true and not player.items["wings"]:
		$item_5.show()

func hide_buttons(): # hides the buttons
	$item_1.hide()
	$item_2.hide()
	$item_3.hide()
	$item_4.hide()
	$item_5.hide()

func _on_item_1_button_down() -> void:
	if money >= price1:
		money-=price1
		ShopSignals.purchase_1()
		is_item_in_store[0] = false
		$item_1.hide()

func _on_item_2_button_down() -> void:
	if money >= price2:
		money-=price2
		ShopSignals.purchase_2()
		is_item_in_store[1] = false
		$item_2.hide()

func _on_item_3_button_down() -> void:
	if money >= price3:
		money-=price3
		ShopSignals.purchase_3()
		is_item_in_store[2] = false
		$item_3.hide()

func _on_item_4_button_down() -> void:
	if money >= price4:
		money-=price4
		ShopSignals.purchase_4()
		is_item_in_store[3] = false
		$item_4.hide()

func _on_item_5_button_down() -> void:
	if money >= price5:
		money-=price5
		ShopSignals.purchase_5()
		is_item_in_store[4] = false
		$item_5.hide()

