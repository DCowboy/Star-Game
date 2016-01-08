#need to fix
extends 'res://ships/ship.gd'

const ship_name = 'terran_interceptor'
var core = 3
var weapon_sys = 3
var engineering = 3

func _ready():
	#setting up ship
	name = ship_name
	size = 0
	previous_pos = get_pos()
	current_pos = get_pos()
	burners.append(get_node('hull/burner_center'))
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	#setting up status and cargo
	status = owner.current_ship_instance.status
	cargo = owner.current_ship_instance.cargo
	cargo.of_ship = self
	status.ship_of = self
	status.set_core(core)
	max_health = core * 50
	status.set_hull_strength(max_health)
	status.set_engineering(engineering)
	max_energy = engineering * 50
	health = max_health
	energy = max_energy
	status.set_weapon_sys(weapon_sys)
	payload_modifier = weapon_sys
	weapons['medium_laser'] = preload('res://ships/equipment/laser_cannon.scn').instance()
	self.get_node('hull/main_cannon').add_child(weapons.medium_laser)
	current_weapon = weapons.medium_laser
	shield_strength = status.defense * 5
	status.set_shield_strength(shield_strength)
	status.set_mass(get_mass())
	status.set_weapon_payload(current_weapon.payload * payload_modifier)
	status.set_weapon_range(current_weapon.fire_range)





