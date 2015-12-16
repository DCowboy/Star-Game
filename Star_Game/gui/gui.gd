
extends CanvasLayer
var map_name


func _ready():
	map_name = get_node("map_and_missions/Label")
	map_name.set_text(get_node("/root/globals").map_name)
	get_node("status_bg/status_holder").add_child(get_node("/root/globals").player.status.instance())
	pass




func _on_TextureButton_pressed():
	pass # replace with function body



func _on_raise_status_window_pressed():
	var window_pos = get_node("status_bg").get_pos()
	if window_pos.y == 665:
		get_node("status_bg").set_pos(Vector2(window_pos.x, 465))
	else:
		get_node("status_bg").set_pos(Vector2(window_pos.x, 665))



func _on_raise_status_window_toggled( pressed ):

	pass # replace with function body
