#need a better way to do mouseover identity color
extends Area2D

const name = 'cursor'
var mouse_position = Vector2(0, 0)
var cursor_position = Vector2(0, 0)
var on_object
var cursor_frame = 0
var player
var globals

func _ready():
	globals = get_node("/root/globals")
	player = get_node("/root/player")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	
	print(get_parent().get_name())
	set_process_input(true)
	set_process(true)


	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		mouse_position = event.pos
		
		
		
		
func _process(delta):
	var offset = -get_viewport_rect().size  / 2
	var zoom = player.get_node("Camera2D").get_zoom()
	cursor_position =  player.get_pos() + (offset + mouse_position) * zoom
	self.set_pos(cursor_position)
	
	on_object = get_overlapping_bodies()
	on_object += get_overlapping_areas()
	if on_object.size() > 0:
		var top_object = on_object[on_object.size() - 1]
		if player.race in top_object.get_groups() or 'item' in top_object.get_groups():
			cursor_frame = 1
		elif not player.race in top_object.get_groups() and not 'resource' in top_object.get_groups():
			cursor_frame = 2
		else:
			cursor_frame = 0
	else:
		cursor_frame = 0
	globals.cursor_frame = cursor_frame
