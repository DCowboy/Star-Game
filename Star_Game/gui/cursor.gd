#need a better way to do mouseover identity color
extends Sprite

var on_object
var cursor_frame = 0

func _ready():
	cursor_frame = get_frame()
	Input.set_mouse_mode(1)
	set_process_input(true)
	set_process(true)


	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		self.set_pos(event.pos)
		
		
func _process(delta):
	var on_object = get_node("/root/globals").mouse_is_over
	if on_object:
		if get_node("/root/player").race in on_object.get_groups() or 'item' in on_object.get_groups():
			cursor_frame = 1
		elif 'neutral' in on_object.get_groups() or not get_node("/root/player").race in on_object.get_groups():
			cursor_frame = 2
		else:
			cursor_frame = 0
	else:
		cursor_frame = 0
	set_frame(cursor_frame)
