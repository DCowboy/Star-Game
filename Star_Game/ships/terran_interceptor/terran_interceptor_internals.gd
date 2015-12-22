
extends 'res://ships/ship.gd'

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	name = 'terran_interceptor'
	size = 0
	size_name = 'small'
	variation = 0
	variation_name = 'defensive'
#	status = preload('res://ships/terran_interceptor/terran_interceptor_status.scn')
#	status.instance()
#	cargo = preload('res://ships/small_normal_inventory.scn')
#	cargo.instance()
	base_thrust = 1000
	weapons['medium_laser'] = preload('res://ships/equipment/laser_cannon.scn')
	get_node('hull/main_cannon').add_child(weapons.medium_laser.instance())
	current_weapon = weapons.medium_laser
	previous_pos = get_pos()
	add_child(controls)
	get_node("/root/player").scale = get_node("Camera2D").get_zoom()
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	engines_disengage()
	pass


func engines_engage():
	get_node("hull/burner_center").set_emitting(true)
	
func engines_disengage():
	get_node("hull/burner_center").set_emitting(false)


