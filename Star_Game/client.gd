
extends Node2D
var lbl_coords

func _fixed_process(delta):

	lbl_coords.set_text("map: " + str(int(get_node("Player").get_pos().x)) + ", " + str(int(get_node("Player").get_pos().y)))

	
func _ready():
	lbl_coords = get_node("gui_layer/map-coords-temp")
#	lbl_coords.set_pos(Vector2(-get_viewport_rect().size / 2 + lbl_coords.get_size()))
	lbl_coords.set_pos(Vector2(0, 0))
	set_fixed_process(true)
