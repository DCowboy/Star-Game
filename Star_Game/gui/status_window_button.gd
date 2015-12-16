
extends TextureButton

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process_input(true)
	pass


func _input(event):
	if event.is_action("status") and event.is_pressed():
		var window_pos = get_parent().get_pos()
		if window_pos.y == 665:
			get_parent().set_pos(Vector2(window_pos.x, 465))
		else:
			get_parent().set_pos(Vector2(window_pos.x, 665))
	pass

	
func _toggled(pressed):
	print ('action fired')
	var window_pos = get_parent().get_pos()
	if window_pos.y == 665:
		get_parent().set_pos(Vector2(window_pos.x, 465))
	else:
		get_parent().set_pos(Vector2(window_pos.x, 665))