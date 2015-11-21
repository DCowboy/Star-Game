
extends Area2D

var pings = []

func _ready():
	# Initialization here
	set_fixed_process(true)


func _fixed_process(delta):
	if get_node("/root/globals").player_pos != null:
		set_pos(get_node("/root/globals").player_pos)
	pings = get_overlapping_bodies()
	pings += get_overlapping_areas()
	get_node("/root/globals").pings = pings
	


