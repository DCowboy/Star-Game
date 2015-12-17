
extends Node2D

var rotate = 0

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
			if not get_parent().shields_up:
				get_parent().engage = true
		else:
			get_parent().engage = false
	elif event.is_action("decelerate"):
		if event.is_pressed():
			get_parent().brake = true
		else:
			get_parent().brake = false
	
	if event.is_action("fire"):
		if event.is_pressed():
			if not get_parent().shields_up:
				get_parent().fire = true
	elif event.is_action("shields"):
		if event.is_pressed():
			if not get_parent().engage:
				get_parent().shields_up = true
		else:
			if get_parent().shields_up:
				get_parent().shields_up = false