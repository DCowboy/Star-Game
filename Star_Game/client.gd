
extends Node2D
var lbl_coords

func _process(delta):
	lbl_coords.clear()
	lbl_coords.add_text("map: " + str(int(get_node("Player").get_pos().x)) + ", " + str(int(get_node("Player").get_pos().y)))

	
func _ready():
	lbl_coords = get_node("gui/map-coords-temp")
	set_process(true)
