
extends CanvasLayer
var map_name


func _ready():
	map_name = get_node("map_and_missions/map_name")
	map_name.set_text(get_node("/root/globals").map_name)
	get_node("status_control/status_bg/status_holder").add_child(get_node("/root/globals").player.status.instance())
	set_process_input(true)
	pass


func _input(event):
	if event.is_action("status") and event.is_pressed():
		var window_pos = get_node("status_control").get_pos()
		if window_pos.y >= 0:
			get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y - 200))
		else:
			get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y + 200))





func _on_window_control_toggled( pressed ):
	var window_pos = get_node("status_control").get_pos()
	if window_pos.y >= 0:
		get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y - 200))
	else:
		get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y + 200))
