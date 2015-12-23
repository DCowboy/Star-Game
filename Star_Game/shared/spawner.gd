
extends Node2D

var globals
var poor_dead_bastard

func _ready():
	globals = get_node("/root/globals")
	pass

func wait(name, race):
	print('starting respawn wait')
	poor_dead_bastard = {'name':name, 'race':race}
	if poor_dead_bastard.race != 'neutral':
		get_node("Timer").start()
	


func _on_Timer_timeout():
	print('waiting over')
	get_node("Timer").stop()
	spawn(poor_dead_bastard.name, poor_dead_bastard.race)
		


func spawn(name, race):
	var respawn_pos
	if race == 'terran':
		respawn_pos = globals.terran_base.get_pos()
		randomize()
		respawn_pos.x += int(rand_range(-1,1) * 250)
		respawn_pos.y += int(rand_range(-1, 1) * 250)
	else:
		respawn_pos = Vector2(0, 0)
	if name == 'player':
		print('respawning')
		var spawn = globals.player.instance() #get_node("/root/player").current_ship.instance()
		spawn.controls = load('res://player/player_control.gd').new()
#		spawn.owner = get_node("/root/player")
		spawn.set_pos(respawn_pos)
		get_node("/root/client").add_child(spawn)
		get_node("/root/client").move_child(spawn, 1)
		globals.player_current_ship = spawn
		globals.population += 1