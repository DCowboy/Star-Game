
extends Node2D

var globals
var player
var gui
var cursor

func _ready():
	globals = get_node("/root/globals")
	var player = get_node("/root/player")
	var map = globals.maps.nebula_01.instance()
	add_child(map)
	move_child(map, 0)
	globals.full_populate()
	get_node("/root/spawner").spawn(player, [player.race, 'ships', 'creation', 'entity'])
	gui = preload('res://gui/gui.scn').instance()
	add_child(gui)
	cursor = preload('res://gui/cursor.scn').instance()
	add_child(cursor)
	set_process(true)
	
func _process(delta):
	pass

