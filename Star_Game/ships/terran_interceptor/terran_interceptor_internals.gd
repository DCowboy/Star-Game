#need to fix
extends 'res://ships/ship.gd'

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	name = 'terran_interceptor'
	size = 0
	size_name = 'small'
	status = owner.current_ship_instance.status
	cargo = owner.current_ship_instance.cargo
	previous_pos = get_pos()
	current_pos = get_pos()
	if 'scale' in owner:
		owner.scale = Vector2(1, 1)
	burners.append(get_node('hull/burner_center'))
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	max_health = status.get_core() * 50
	status.set_hull_strength(max_health)
	max_energy = status.get_engineering() * 50
	health = max_health
	energy = max_energy
	payload_modifier = status.get_weapons()
	weapons['medium_laser'] = preload('res://ships/equipment/laser_cannon.scn').instance()
	self.get_node('hull/main_cannon').add_child(weapons.medium_laser)
	current_weapon = weapons.medium_laser
	shield_strength = ceil((status.get_weapons() + status.get_core()) / 2) * 5
	status.set_shield_strength(shield_strength)
	status.set_mass(get_mass())
	status.set_weapon_payload(current_weapon.payload * payload_modifier)
	status.set_weapon_range(current_weapon.fire_range)

	status.set_mass(get_mass())
	status.set_weapon_payload(current_weapon.payload * payload_modifier)






