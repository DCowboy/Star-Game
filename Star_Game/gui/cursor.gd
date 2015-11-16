
extends Sprite

func _ready():
	Input.set_mouse_mode(1)
	set_process_input(true)
	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		self.set_pos(event.pos)
