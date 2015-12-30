#need to fix

extends 'res://ships/ship.gd'

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	name = 'terran_corvette'
	size = 1
	size_name = 'medium'
	status = owner.current_ship_instance.status
	cargo = owner.current_ship_instance.cargo
	weapons['medium_laser'] = preload('res://ships/equipment/laser_cannon.scn').instance()
	self.get_node('hull/main_cannon').add_child(weapons.medium_laser)
	current_weapon = weapons.medium_laser
	previous_pos = get_pos()
	current_pos = get_pos()
	if 'scale' in owner:
		owner.scale = Vector2(1.5, 1.5)
	burners.append(get_node('hull/burner_left'))
	burners.append(get_node('hull/burner_right'))
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	max_health = status.core_get() * 50
	max_energy = status.engineering_get() * 50
	health = max_health
	energy = max_energy
	shield_strength = ceil((status.weapons_get() + status.core_get()) / 2) * 5
	pass


