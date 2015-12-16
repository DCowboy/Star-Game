
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	pass


func _input(event):
	if event.is_action("status") and event.is_pressed():
		var window_pos = get_pos()
		if window_pos.y == 665:
			set_pos(Vector2(window_pos.x, 465))
		else:
			set_pos(Vector2(window_pos.x, 665))


func _on_window_control_toggled( pressed ):
	print ('action fired')
	var window_pos = get_pos()
	if window_pos.y == 665:
		set_pos(Vector2(window_pos.x, 465))
	else:
		set_pos(Vector2(window_pos.x, 665))



func _on_window_control_pressed():
	print ('action fired from pressed')
	var window_pos = get_pos()
	if window_pos.y == 665:
		set_pos(Vector2(window_pos.x, 465))
	else:
		set_pos(Vector2(window_pos.x, 665))
	pass # replace with function body
