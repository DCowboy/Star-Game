extends Node2D

var globals
var display
var of_ship
var max_slots
var currently_used = {}
var used = 0
var item_highlighted = false
var highlighted_item 

func _ready():
	globals = get_node("/root/globals")
	display = get_parent().get_parent()
	max_slots = get_child_count() 
	display.get_node("max_space").set_text(str(max_slots))
	display.get_node("used").set_text(str(currently_used.size()))
	set_process(true)


func _process(delta):
	if used !=  currently_used.size():
		display.get_node("used").set_text(str(currently_used.size()))
		used = currently_used.size()


func check_room():
	if currently_used != null and currently_used.size() < max_slots:
		return true
	else:
		if 'player_type' in of_ship.owner.get_groups():
			display.get_node('message').set_text('***CARGO HOLD FULL***')
		return false


func add_item(item):
	var slot_pos = 0
	for slot in get_children():
		if slot.get_child_count() < 3:
			item.set_pos(Vector2(0, 0))
			item.set_scale(Vector2(1, 1))
			item.owner = get_node("/root/player").current_ship_instance.hull
			item.update()
			slot.add_child(item)
			slot.move_child(item, 0)
			currently_used[item] = slot_pos
			display.get_node('message').set_text('Last acquired ' + item.name)
		else:
			slot_pos += 1
		slot.update()
	
	
func move_item(item, pos):
	item.get_parent().remove_child(item)
	pos.add_child(item)
	pos.move_child(item, 0)
	
	
func switch_item(pos1, pos2):
	var slot1 = get_child(pos1)
	var slot2 = get_child(pos2)
	var item1 = slot1.get_child(0)
	var item2 = slot2.get_child(0)
	slot1.remove_child(item1)
	slot2.remove_child(item2)
	slot1.add_child(item2)
	slot1.move_child(item2, 0)
	slot2.add_child(item1)
	slot2.move_child(item1, 0)
	display.get_node('message').set_text('Last switched contents of slot ' + str(pos1 + 1) + ' and slot ' + str(pos2 + 1))
	
	
func slide_items(start_pos):
	for pos in range(start_pos, get_child_count()):
		if pos + 1 != get_child_count() and 'object' in get_child(pos + 1).get_child(0).get_groups():
			var object = get_child(pos + 1).get_child(0)
			get_child(pos + 1).remove_child(object)
			get_child(pos).add_child(object)
			get_child(pos).move_child(object, 0)
		else:
			break
	
	
func use_item(item):
	item.use_item()
	slide_items(currently_used[item])


func on_button_pressed(button):
	var slot_clicked = get_child(button)
	#need to think about and implement determination between empty and not empty as well as highlighted or not.
	if item_highlighted == false and slot_clicked.get_child(0) != slot_clicked.get_node('highlight'):
		slot_clicked.get_node('highlight').show()
		highlighted_item = button
		display.get_node('message').set_text('Click again to use, or click on new slot to \n move to.')
		item_highlighted = true
	elif item_highlighted == true and slot_clicked == get_child(highlighted_item):
		get_child(highlighted_item).get_node('highlight').hide()
		var item = slot_clicked.get_child(0)
		display.get_node('message').set_text('Last used ' + item.name)
		item_highlighted = false
		use_item(item)
	elif item_highlighted == true and slot_clicked.get_child(0) == slot_clicked.get_node('highlight'):
		var item = get_child(highlighted_item).get_child(0)
		display.get_node('message').set_text('moved ' + item.name + ' from slot ' + str(highlighted_item + 1) + ' to slot ' + str(button + 1))
		item_highlighted = false
		get_child(highlighted_item).get_node('highlight').hide()
		move_item(item, slot_clicked)
	elif item_highlighted == true and slot_clicked.get_child(0) != slot_clicked.get_node('highlight'):
		item_highlighted = false
		get_child(highlighted_item).get_node('highlight').hide()
		switch_item(highlighted_item, button)
	else:
		display.get_node('message').set_text('If you wish to move an item here, click the \n item you wish to move first.')

