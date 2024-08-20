extends Node

signal item_1
signal item_2
signal item_3
signal item_4
signal item_5

func purchase_1():
	emit_signal("item_1")
	
func purchase_2():
	emit_signal("item_2")

func purchase_3():
	emit_signal("item_3")
	
func purchase_4():
	emit_signal("item_4")

func purchase_5():
	emit_signal("item_5")
