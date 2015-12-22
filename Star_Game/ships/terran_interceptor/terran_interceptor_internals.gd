
extends 'res://ships/ship.gd'

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	name = 'terran_interceptor'
	race = 'terran'
	size = 0
	size_name = 'small'
	variation = 0
	variation_name = 'defensive'
	status = preload('res://ships/terran_interceptor/terran_interceptor_status.scn').instance()
#	get_node('/client/gui/status_control/status_bg/status_holder').add_child(status.instance())
	cargo = preload('res://ships/small_normal_inventory.scn').instance()
#	get_node('/client/gui/inventory_control/items_bg/cargo_holder').add_child(cargo.instance())
	base_thrust = 1000
	weapons['medium_laser'] = preload('res://ships/equipment/laser_cannon.scn').instance()
	self.get_node('hull/main_cannon').add_child(weapons.medium_laser)
	current_weapon = weapons.medium_laser
	previous_pos = get_pos()
	current_pos = get_pos()
	get_node("/root/globals").player_scale = get_node("Camera2D").get_zoom()
	burners.append(get_node('hull/burner_center'))
	owner = 'player'
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	add_child(controls)
	max_health = status.def_get() * 50
	max_energy = status.spd_get() * 50
	health = max_health
	energy = max_energy
	shield_strength = ceil(status.pwr_get() / 2 + status.def_get() / 2) * 5
	print(str(health) + ' ' + str(energy))
	pass





