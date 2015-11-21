
extends Node2D
var lbl_coords


func _process(delta):
	lbl_coords.set_text("map: " + str(int(get_node("Player").get_pos().x)) + ", " + str(int(get_node("Player").get_pos().y)))


func _ready():
	lbl_coords = get_node("gui_layer/map-coords-temp")
	lbl_coords.set_pos(Vector2(0, 0))
	set_process(true)
