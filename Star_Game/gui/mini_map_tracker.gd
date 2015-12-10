
extends Area2D

var ping_bodies = []
var ping_areas = []

func _ready():
	#sets size of area to check based on viewport size
#	var scale = get_node("/root/globals").main_viewport.size.width / get_node("/root/globals").basis_viewport.size.width
	var current_transform = get_shape_transform(0)
	set_shape_transform(0, current_transform.scaled(get_node("/root/globals").square_scale))
	set_fixed_process(true)


func _fixed_process(delta):
	#follow the player if it's there
	if get_node("/root/globals").player_pos != null:
		set_pos(get_node("/root/globals").player_pos)
	#attempt to get overlapping bodies and areas
	#TODO: fix minimap to show areas
	ping_bodies = get_overlapping_bodies()
	ping_areas = get_overlapping_areas()
#	pings += get_overlapping_areas()
	get_node("/root/globals").ping_objects = ping_bodies
	get_node("/root/globals").ping_areas = ping_areas
	


