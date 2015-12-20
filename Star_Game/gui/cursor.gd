
extends Sprite

var on_object
var cursor_frame
var player_race = null

func _ready():
	cursor_frame = get_frame()
	Input.set_mouse_mode(1)
	set_process_input(true)
	set_process(true)


	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		self.set_pos(event.pos)
		
		
func _process(delta):
	if player_race != get_node("/root/globals").player_race:
		player_race = get_node("/root/globals").player_race
	var on_object = get_node("/root/globals").mouse_is_over
	if on_object == null:
		cursor_frame = 0
	elif on_object.type == 'asteroid' or on_object.race != player_race:
		cursor_frame = 2
	elif on_object.type == 'ship' and on_object.race == player_race:
		cursor_frame = 1
	set_frame(cursor_frame)
