
extends Node2D
var lbl_coords

func _process(delta):
	lbl_coords.clear()
	lbl_coords.add_text("map: " \
	+ str(int(get_node("Player").get_pos().x) / 10) \
	+ ", " + str(int(get_node("Player").get_pos().y) / 10))

	
func _ready():
	lbl_coords = get_node("Player/Camera2D/gui/map_coords")
	set_process(true)
