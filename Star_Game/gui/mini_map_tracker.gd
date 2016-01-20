
extends Area2D
var shape
var current_transform
var owner_scale = Vector2(0, 0)
var ping_bodies = []
var ping_areas = []
var globals
var owner = null

func _ready():
	globals = get_node("/root/globals")
	shape = get_node("CollisionShape2D").get_collision_object_shape_index()
	current_transform = get_shape_transform(shape)
	#sets size of area to check based on viewport size
#	var scale = get_node("/root/globals").main_viewport.size.width / get_node("/root/globals").basis_viewport.size.width
	
	set_fixed_process(true)


func _fixed_process(delta):
	if owner != null and owner_scale != owner.scale:
		owner_scale = owner.scale
		set_shape_transform(0, current_transform.scaled(owner_scale))
#		get_node("/root/globals").mini_map_size = 
		#follow the player if it's there
	if owner != null and owner.get_pos() != null:
		set_pos(owner.get_pos())
	#attempt to get overlapping bodies and areas
	#TODO: fix minimap to show areas
	ping_bodies = get_overlapping_bodies()
	ping_areas = get_overlapping_areas()
#	pings += get_overlapping_areas()
	owner.ping_objects = ping_bodies
	owner.ping_areas = ping_areas
	

func _screen_size_changed():
	set_shape_transform(0, current_transform.scaled(globals.square_scale))
	