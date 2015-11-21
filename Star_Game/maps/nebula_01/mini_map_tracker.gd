
extends Area2D

var pings = []

func _ready():
	#sets size of area to check based on viewport size
	var scale_x = get_node("/root/globals").main_viewport.size.width / get_node("/root/globals").basis_viewport.size.width
	var scale_y = get_node("/root/globals").main_viewport.size.height / get_node("/root/globals").basis_viewport.size.width
	var current_transform = get_shape_transform(0)
	set_shape_transform(0, current_transform.scaled(Vector2(scale_x, scale_y)))
	set_fixed_process(true)


func _fixed_process(delta):
	#follow the player if it's there
	if get_node("/root/globals").player_pos != null:
		set_pos(get_node("/root/globals").player_pos)
		
	#attempt to get overlapping bodies and areas
	#TODO: fix minimap to show areas
	pings = get_overlapping_bodies()
	pings += get_overlapping_areas()
	get_node("/root/globals").pings = pings
	


