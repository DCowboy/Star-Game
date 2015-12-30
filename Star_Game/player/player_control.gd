
extends Node2D

var rotate = 0
var ship = null

func _ready():
	set_name('controls')
	set_process_input(true)
	pass


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		#have player always point to mouse cursor and set that direction for movement
		var mouse_pos = Vector2(event.pos - get_viewport_rect().size / 2)
		rotate = get_viewport_rect().pos.angle_to_point(mouse_pos)
		get_parent().rotate = rotate 
		
	if event.is_action("accelerate"):
		if event.is_pressed():
			if not ship.shields_up:
				ship.engage = true
		else:
			ship.engage = false
	elif event.is_action("decelerate"):
		if event.is_pressed():
			ship.brake = true
		else:
			ship.brake = false
	
	if event.is_action("fire"):
		if event.is_pressed():
			if not ship.shields_up:
				ship.fire = true
	elif event.is_action("shields"):
		if event.is_pressed():
			if not ship.engage:
				ship.shields_up = true
		else:
			if ship.shields_up:
				ship.shields_up = false
	
	if event.is_action("quit") and event.is_pressed():
		OS.get_main_loop().quit()

func attach_to_ship():
	ship = get_parent().current_ship_instance.hull
