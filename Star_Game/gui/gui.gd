
extends CanvasLayer
var map_name
var status
var cargo
var speed
var spd = 0
var guage_limiter = 0
var guage_limit = 5
var globals
var player


func _ready():
	player = get_node("/root/player")
	globals = get_node("/root/globals")
	map_name = get_node("tactical_control/tactical_bg/map_name")
	map_name.set_text(globals.map_name)
	speed = get_node("tactical_control/tactical_bg/speed")
	status = player.current_ship_instance.status
	get_node("core_control/core/status_holder").add_child(status)
	cargo = player.current_ship_instance.cargo
	get_node("cargo_control/cargo_bg/cargo_holder").add_child(cargo)
	set_process(true)
	
	set_process_input(true)


func _input(event):
	if event.is_action("missions") and event.is_pressed():
		var window_pos = get_node("core_control").get_pos()
		if window_pos.y >= 135:
			get_node("core_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
		else:
			get_node("core_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))
			
	if event.is_action("status") and event.is_pressed():
		var window_pos = get_node("cargo_control").get_pos()
		if window_pos.y >= 0:
			get_node("cargo_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
		else:
			get_node("cargo_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))
	
	if event.is_action("radar") and event.is_pressed():
		var window_pos = get_node("tactical_control").get_pos()
		if window_pos.y >= 135:
			get_node("tactical_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
		else:
			get_node("tactical_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))
	
	if event.is_action("cargo") and event.is_pressed():
		var window_pos = get_node("comm_control").get_pos()
		if window_pos.y >= 0:
			get_node("comm_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
		else:
			get_node("comm_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))


func _process(delta):
	guage_limiter += 1
	if guage_limiter >= guage_limit and spd != player.speed:
		spd = player.speed
		if spd > 0:
			speed.set_text(str(round(spd * 100) / 100))
		else:
			speed.set_text('0.00')
		guage_limiter = 0



func _on_window_control_toggled( pressed ):
	var window_pos = get_node("cargo_control").get_pos()
	if window_pos.y >= 0:
		get_node("cargo_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
	else:
		get_node("cargo_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))


func _on_radar_control_toggled( pressed ):
	var window_pos = get_node("tactical_control").get_pos()
	if window_pos.y >= 135:
		get_node("tactical_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
	else:
		get_node("tactical_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))



func _on_missions_button_toggled( pressed ):
	var window_pos = get_node("core_control").get_pos()
	if window_pos.y >= 135:
		get_node("core_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
	else:
		get_node("core_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))


func _on_cargo_hold_button_toggled( pressed ):
	var window_pos = get_node("comm_control").get_pos()
	if window_pos.y >= 0:
		get_node("comm_control").set_pos(Vector2(window_pos.x, window_pos.y - 256))
	else:
		get_node("comm_control").set_pos(Vector2(window_pos.x, window_pos.y + 256))
	


