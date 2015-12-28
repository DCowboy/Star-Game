
extends Node2D

var globals

func _ready():
	globals = get_node("/root/globals")
#	var player = get_node("/root/player").current_ship
	var map = globals.maps.nebula_01.instance()
	add_child(map)
	move_child(map, 0)
	get_node("/root/spawner").spawn('player', ['terran', 'ships', 'creation', 'entity'])
	globals.player_pos = get_child(1).get_pos()
	globals.full_populate()
	var gui = preload('res://gui/gui.scn').instance()
	add_child(gui)
	pass
