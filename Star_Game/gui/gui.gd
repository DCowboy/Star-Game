
extends CanvasLayer
var map_name
var status
var cargo
var speed
var spd = 0
var guage_limiter = 0
var guage_limit = 5
var cursor
var globals
var player


func _ready():
	player = get_node("/root/player")
	globals = get_node("/root/globals")
	map_name = get_node("missions_control/map_and_missions/map_name")
	map_name.set_text(globals.map_name)
	speed = get_node("mini_map_control/mini-map_and _speed/speed")
	status = player.current_ship_instance.status
	get_node("status_control/status_bg/status_holder").add_child(status)
	cargo = player.current_ship_instance.cargo
	get_node("inventory_control/items_bg/cargo_holder").add_child(cargo)
	cursor = get_node("cursor")
	set_process(true)
	
	set_process_input(true)


func _input(event):
	if event.is_action("missions") and event.is_pressed():
		var window_pos = get_node("missions_control").get_pos()
		if window_pos.y >= 135:
			get_node("missions_control").set_pos(Vector2(window_pos.x, window_pos.y - 205))
		else:
			get_node("missions_control").set_pos(Vector2(window_pos.x, window_pos.y + 205))
			
	if event.is_action("status") and event.is_pressed():
		var window_pos = get_node("status_control").get_pos()
		if window_pos.y >= 0:
			get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y - 195))
		else:
			get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y + 195))
	
	if event.is_action("radar") and event.is_pressed():
		var window_pos = get_node("mini_map_control").get_pos()
		if window_pos.y >= 135:
			get_node("mini_map_control").set_pos(Vector2(window_pos.x, window_pos.y - 205))
		else:
			get_node("mini_map_control").set_pos(Vector2(window_pos.x, window_pos.y + 205))
	
	if event.is_action("cargo") and event.is_pressed():
		var window_pos = get_node("inventory_control").get_pos()
		if window_pos.y >= 0:
			get_node("inventory_control").set_pos(Vector2(window_pos.x, window_pos.y - 195))
		else:
			get_node("inventory_control").set_pos(Vector2(window_pos.x, window_pos.y + 195))


func _process(delta):
	guage_limiter += 1
	if guage_limiter >= guage_limit and spd != player.speed:
		spd = player.speed
		if spd > 0:
			speed.set_text(str(round(spd * 100) / 100))
		else:
			speed.set_text('0')
		guage_limiter = 0



func _on_window_control_toggled( pressed ):
	var window_pos = get_node("status_control").get_pos()
	if window_pos.y >= 0:
		get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y - 195))
	else:
		get_node("status_control").set_pos(Vector2(window_pos.x, window_pos.y + 195))


func _on_radar_control_toggled( pressed ):
	var window_pos = get_node("mini_map_control").get_pos()
	if window_pos.y >= 135:
		get_node("mini_map_control").set_pos(Vector2(window_pos.x, window_pos.y - 205))
	else:
		get_node("mini_map_control").set_pos(Vector2(window_pos.x, window_pos.y + 205))



func _on_missions_button_toggled( pressed ):
	var window_pos = get_node("missions_control").get_pos()
	if window_pos.y >= 135:
		get_node("missions_control").set_pos(Vector2(window_pos.x, window_pos.y - 205))
	else:
		get_node("missions_control").set_pos(Vector2(window_pos.x, window_pos.y + 205))


func _on_cargo_hold_button_toggled( pressed ):
	var window_pos = get_node("inventory_control").get_pos()
	if window_pos.y >= 0:
		get_node("inventory_control").set_pos(Vector2(window_pos.x, window_pos.y - 195))
	else:
		get_node("inventory_control").set_pos(Vector2(window_pos.x, window_pos.y + 195))
	


