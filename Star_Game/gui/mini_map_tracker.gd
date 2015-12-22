
extends Area2D
var shape
var current_transform
var player_scale = Vector2(0, 0)
var ping_bodies = []
var ping_areas = []
var globals

func _ready():
	globals = get_node("/root/globals")
	shape = get_node("CollisionShape2D").get_collision_object_shape_index()
	current_transform = get_shape_transform(shape)
	#sets size of area to check based on viewport size
#	var scale = get_node("/root/globals").main_viewport.size.width / get_node("/root/globals").basis_viewport.size.width
	
	set_fixed_process(true)


func _fixed_process(delta):
	if player_scale != globals.player_scale:
		player_scale = globals.player_scale
		set_shape_transform(0, current_transform.scaled(player_scale))
#		get_node("/root/globals").mini_map_size = 
		#follow the player if it's there
	if globals.player_pos != null:
		set_pos(globals.player_pos)
	#attempt to get overlapping bodies and areas
	#TODO: fix minimap to show areas
	ping_bodies = get_overlapping_bodies()
	ping_areas = get_overlapping_areas()
#	pings += get_overlapping_areas()
	globals.ping_objects = ping_bodies
	globals.ping_areas = ping_areas
	

func _screen_size_changed():
	set_shape_transform(0, current_transform.scaled(globals.square_scale))