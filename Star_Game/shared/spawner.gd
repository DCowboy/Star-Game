#need to fix
extends Node2D

var globals
var poor_dead_bastard
var tracer

func _ready():
	tracer = preload("res://gui/mini_map_tracker.scn")
	globals = get_node("/root/globals")
	pass

func wait(owner, groups, time=0.75):
	get_node("ship_timer").set_wait_time(time)
	print('starting respawn wait')
	poor_dead_bastard = {'owner': owner, 'groups': groups}
	if not 'neutral' in poor_dead_bastard.groups:
		get_node("ship_timer").start()
	


func _on_Timer_timeout():
	print('waiting over')
	get_node("ship_timer").stop()
	spawn(poor_dead_bastard.owner, poor_dead_bastard.groups)
		


func spawn(owner, groups):
	var spawn
	var tail = tracer.instance()
	var respawn_pos
	if 'terran' in groups:
		respawn_pos = globals.terran_base.get_global_pos()
	else:
		respawn_pos = Vector2(0, 0)
	if owner.name == 'player':
		print('respawning')
		spawn = owner.current_ship.instance() #get_node("/root/player").current_ship.instance()
		owner.current_ship_instance.hull = spawn
		owner.controls.attach_to_ship()
		if owner.get_node("Camera2D").is_current() == false:
			owner.get_node('Camera2D').make_current()
#		globals.player_current_ship = spawn
#		spawn.controls = load('res://player/player_control.gd').new()
#		spawn.owner = get_node("/root/player")
	randomize()
	respawn_pos.x += int(rand_range(-1,1) * 250)
	respawn_pos.y += int(rand_range(-1, 1) * 250)
	spawn.owner = owner
	tail.owner = owner
	spawn.set_pos(respawn_pos)
	get_node("/root/client").add_child(spawn)
	get_node("/root/client").add_child(tail)
#		get_node("/root/client").move_child(spawn, 1)
		
	globals.population += 1