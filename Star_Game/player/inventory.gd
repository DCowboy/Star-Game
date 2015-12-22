
extends Node2D

var display
var max_slots
var currently_used = {}
var used = 0

func _ready():
	display = get_parent().get_parent()
	max_slots = get_child_count()
	display.get_node("max_space").set_text(str(max_slots))
	display.get_node("used").set_text(str(currently_used.size()))
	set_process(true)
	pass


func _process(delta):
	if used !=  currently_used.size():
		display.get_node("used").set_text(str(currently_used.size()))
		used = currently_used.size()


func add_item(item):
	if currently_used.size() < max_slots:
		for slot in get_children():
			if slot.get_child_count() == 0:
				item.set_pos(Vector2(0, 0))
				item.set_transform(Matrix32(Vector2(.5,-0), Vector2(0, .5), get_pos()))
				item.owner = get_node("/root/globals").player_current_ship
				slot.add_child(item)
				currently_used[item] = 1
			slot.update()
	else:
		print('inventory full')
			
	display.get_node("used").set_text(str(currently_used.size()))