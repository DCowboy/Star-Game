
extends Node2D


func _ready():
	var map = get_node("/root/globals").maps.nebula_01.instance()
	var gui = preload('res://gui/gui.scn').instance()
	add_child(map)
	move_child(map, 0)
	get_node("/root/spawner").spawn('Player', 'terran')
	get_node("/root/globals").player_pos = get_child(1).get_pos()
	get_node("/root/globals").full_populate()
	add_child(gui)
	pass
