
extends Sprite

var mouse_pos = Vector2(0, 0)
var globals

func _ready():
	globals = get_node("/root/globals")
	set_process_input(true)
	set_process(true)
	
	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		mouse_pos = event.pos
		globals.mouse_pos
		set_pos(mouse_pos)
	
func _process(delta):
	set_frame(globals.cursor_frame)
#	if get_node("/root/client/cursor") != null:
#		set_pos(mouse_pos)
#	else:
#		for child in get_node("/root/client").get_children():
#			print(child.get_name())