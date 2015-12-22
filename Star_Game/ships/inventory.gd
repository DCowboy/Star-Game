
extends Node2D

var display
var max_slots
var currently_used = {'item':null, 'count':0}


func _ready():
	display = get_parent().get_parent()
	max_slots = get_child_count()
	display.get_node("max_space").set_text(str(max_slots))
	display.get_node("used").set_text(str(currently_used.size()))
	pass

func add_item(item):
	if item in currently_used:
		currently_used.item += 1
	else:
		currently_used[item] = 1