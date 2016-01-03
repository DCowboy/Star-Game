#need a better way to do mouseover identity color
extends Sprite

var mouse_position = Vector2(0, 0)
var on_object
var cursor_frame = 0

func _ready():
	cursor_frame = get_frame()
#	Input.set_mouse_mode(1)
	Input.MOUSE_MODE_CAPTURED
	set_process_input(true)
	set_process(true)


	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		mouse_position = get_node("/root/player").get_node("Camera2D").get_global_pos() + (-get_viewport_rect().size / 2  * get_viewport_transform().get_scale()) + event.pos
		self.set_pos(mouse_position)
		
		
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
