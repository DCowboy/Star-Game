extends Node2D

var globals
var display
var of_ship
var max_slots
var currently_used = {}
var used = 0
var message_timer

func _ready():
	globals = get_node("/root/globals")
	display = get_parent().get_parent()
	max_slots = get_child_count() 
	display.get_node("max_space").set_text(str(max_slots))
	display.get_node("used").set_text(str(currently_used.size()))
	set_process(true)
	message_timer = Timer.new()
	message_timer.set_timer_process_mode(message_timer.TIMER_PROCESS_IDLE)
	message_timer.set_wait_time(1)
	pass


func _process(delta):
	if used !=  currently_used.size():
		display.get_node("used").set_text(str(currently_used.size()))
		used = currently_used.size()


func check_room():
	if currently_used != null and currently_used.size() < max_slots:
		return true
	else:
		if 'player_type' in of_ship.owner.get_groups() and message_timer.get_time_left() <= .01:
			message_timer.start()
			globals.comm.message('***CARGO HOLD FULL***')
		return false


func add_item(item):
	for slot in get_children():
		if slot.get_child_count() == 0:
			item.set_pos(Vector2(0, 0))
			item.set_scale(Vector2(1, 1))
			item.owner = get_node("/root/player").current_ship_instance.hull
			item.update()
			slot.add_child(item)
			currently_used[item] = 1
		slot.update()

			
	display.get_node("used").set_text(str(currently_used.size()))