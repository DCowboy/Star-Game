#need to fix
extends Node2D

var ship_of
var mass = 0 setget set_mass, get_mass
var core = 0 setget set_core, get_core
var hull_strength = 0 setget set_hull_strength, get_hull_strength
var engineering = 0 setget set_engineering, get_engineering
var thrust = 0 setget set_thrust, get_thrust
var supply = 0 
var weapon_sys = 0 setget set_weapon_sys, get_weapon_sys
var weapon_range = 0 setget set_weapon_range, get_weapon_range
var weapon_payload = 0 setget set_weapon_payload, get_weapon_payload
var defense = 0
var shield_strength = 0 setget set_shield_strength, get_shield_strength
var tactical = 0


var display

func _ready():
	display = get_parent().get_parent()
	display.get_node('engineering').set_text(str(engineering))
	display.get_node('core').set_text(str(core))
	display.get_node('weapons').set_text(str(weapon_sys))
	display.get_node('supply').set_text(str(supply))
	display.get_node('tactical').set_text(str(tactical))
	display.get_node('defense').set_text(str(defense))
	display.get_node('mass').set_text(str(mass))
	display.get_node('thrust').set_text(str(thrust))
	display.get_node('range').set_text(str(weapon_range))
	display.get_node('shield_str').set_text(str(shield_strength))
	display.get_node('weapon_pwr').set_text(str(weapon_payload))
	display.get_node('hull_strength').set_text(str(hull_strength))
	set_process(true)
	
	
func _process(delta):

	pass



func set_mass(new_value):
	mass = new_value
	if display:
		display.get_node('mass').set_text(str(mass))
	
func get_mass():
	return mass
	

func set_weapon_sys(new_value):
	weapon_sys = new_value
	defense = ceil((core + weapon_sys) * .5)
	tactical = ceil((engineering + weapon_sys) * .5)
	if display:
		display.get_node('weapons').set_text(str(weapon_sys))
		display.get_node('tactical').set_text(str(tactical))
		display.get_node('defense').set_text(str(defense))
	
	
func get_weapon_sys():
	return weapon_sys
	

func set_weapon_range(new_value):
	weapon_range = new_value
	if display:
		display.get_node('range').set_text(str(weapon_range))
	
	
func get_weapon_range():
	return weapon_range
	
	
func set_weapon_payload(new_value):
	weapon_payload = new_value
	if display:
		display.get_node('weapon_pwr').set_text(str(weapon_payload))
	
func get_weapon_payload():
	return weapon_payload
	

func set_core(new_value):
	core = new_value
	supply = ceil((engineering + core) * .5)
	defense = ceil((core + weapon_sys) * .5)
	if display:
		display.get_node('core').set_text(str(core))
		display.get_node('supply').set_text(str(supply))
		display.get_node('defense').set_text(str(defense))
	

func get_core():
	return core
	

func set_hull_strength(new_value):
	hull_strength = new_value
	if display:
		display.get_node('hull_strength').set_text(str(hull_strength))
	
	
func get_hull_strength():
	return hull_strength
	
	
func set_shield_strength(new_value):
	shield_strength = new_value
	if display:
		display.get_node('shield_str').set_text(str(shield_strength))
	
	
func get_shield_strength():
	return shield_strength
	
	
func set_engineering(new_value):
	engineering = new_value
	supply = ceil((engineering + core) * .5)
	tactical = ceil((engineering + weapon_sys) * .5)
	if display:
		display.get_node('engineering').set_text(str(engineering))
		display.get_node('supply').set_text(str(supply))
		display.get_node('tactical').set_text(str(tactical))
	
	
func get_engineering():
	return engineering


func set_thrust(new_value):
	thrust = new_value
	if display:
		display.get_node('thrust').set_text(str(thrust))
	
	
func get_thrust():
	return thrust
	

	