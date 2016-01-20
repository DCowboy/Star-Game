
extends Node2D

var globals
var name
var sight_range = Vector2(0, 0)
var aim = Vector2(0, 0) #pseudo mouse cursor position
var rotate = 0
var move_speed # variable to tell ship how fast to go
var brake_to_speed = 0 # speed to brake to
var ship = null
var closest_thing = null
var moving_direction 
var action = 'scout'
var behavior = ''
var previous_state = ''
var state = 'start'
var state_status
var health_condition
var energy_condition
var viability
var capability
var states = {}
var wait = 0
var thinking = 0
var think_speed = 30 

func _ready():
	globals = get_node("/root/globals")
	name = 'small_npc_controls'
	
	rotate = get_parent().rotate
	set_process(true)
	set_fixed_process(true)
	

func attach_to_ship():
	ship = get_parent().current_ship_instance.hull


func _process(delta):
	moving_direction = ship.get_rot()
	sight_range = ship.get_pos() + globals.main_viewport.size / 2
	if ship.health <= 0:
		state = 'start'
		move_speed = null
		state_status = ''
		previous_state = ''
		
	thinking += 1
	
	#gather information
	check_viability(ship)
	check_capability(ship)
	
	#make choices
	make_choices()
	
	#act
	for state in states:
		if state == 'turn':
			turn()
		elif state == 'move':
			ahead()
		elif state == 'wait':
			wait()
		elif state == 'brake':
			brake()
		elif state == 'shoot':
			shoot()


func _fixed_process(delta):

	pass


func check_health(entity):
	return(entity.health / entity.max_health)
	

func check_energy(entity):
	return(entity.energy / entity.max_energy)


func check_viability(entity):
	var groups = entity.get_groups()
	var best
	var entity_health
	var entity_energy
	if 'terran' in groups:
		best = entity.status.get_engineering()
	elif 'chentia' in groups:
		best = entity.status.get_weapon_sys()
	elif 'urthrax' in groups:
		best = entity.status.get_core()
	elif 'asteroids' in groups:
		best = entity.material * entity.size
	elif 'projectiles' in groups:
		best = entity.fire_range - entity.traveled
	elif 'station_defense' in groups:
		best = entity.fire_range
	entity_health = check_health(entity)
	entity_energy = check_energy(entity)
	if entity == ship:
		health_condition = entity_health
		energy_condition = entity_energy
	return(best * (entity_health + entity_energy))


func check_capability(entity):
	var groups = entity.get_groups()
	var offensive
	var defensive
	if 'ships' in groups:
		offensive = entity.weapons.size() * (entity.size + 1)
		defensive = entity.shield_strength * (entity.size + 1)
	elif 'station_defense' in groups:
		if 'terran' in groups:
			offensive = 20
			defensive = 20
		elif 'chentia' in groups:
			offensive = 40
			defensive = 0
		elif 'urthrax' in groups:
			offensive = 0
			defensive = 40
	elif 'asteroid' in groups:
		offensive = 0
		defensive = 0
	elif 'projectile' in groups:
		offensive = entity.payload
		defensive = 0
	
	return(offensive + defensive)





func make_choices():
	var current_state = state
#	if 'health' in needs or ('energy' in needs and needs.energy <= 2):
#		return_to_base()
#	else:
#		scout()

		
		
#	if current_state != state:
#		previous_state = current_state

	if thinking >= think_speed:

		thinking = 0


#!-----actions: bigger actions with costs to decide on-----!
func scout():
	var time
	if state == 'start' or state == 'wait':
		var invalid = true
		brake_to_speed = 50
		while invalid:
			randomize()
			aim.x = rand_range(-sight_range.x, sight_range.x)
			randomize()
			aim.y = rand_range(-sight_range.y, sight_range.y)
			if Vector2(aim - ship.get_pos()).length() > 64:
				invalid = false
		state = 'turn'
	elif state == 'turn' and state_status == 'completed':
		randomize()
		move_speed = rand_range(0, ship.top_speed *.95)
		state = 'move'
	elif state == 'move' and state_status == 'completed':
		time = 1
		state = 'wait'


func return_to_base():
	aim = get_parent().home_station.get_pos()
	if Vector2(get_parent().home_station.get_pos() - ship.get_pos()).length() > 250:
		if state == 'turn' and state_status == 'completed':
			move_speed = ship.top_speed * .95
			state = 'move'
		else:
			brake_to_speed = 50
			
			state = 'turn'
	else:
		if ship.speed > 0:
			state = 'brake'
		else:
			state = 'start'



#!-------states: small actions to take towards bigger actions-----!
func wait(time=1):
	state_status = 'in progress'
	if wait == think_speed * time:
		state_status = 'completed'
	else:
		wait += 1
	

func ahead():
	state_status = 'in progress'
	if  ship.speed < move_speed:
		accelerate()
	else:
		state_status = 'completed'


func brake():
	state_status = 'in progress'
	if ship.speed > brake_to_speed:
		decelerate()
	else:
		state_status = 'completed'


func turn():
	state_status = 'in progress'
	if rotate != ship.get_pos().angle_to_point(aim):
		rotate()
	else:
		state_status = 'completed'


func shoot():
	var things = ship.owner.ping_objects
	for thing in things:
		if Vector2(ship.get_pos() - thing.get_pos()).length() < sight_range.y / 2:
			var direction = Vector2(cos(ship.get_rot() + deg2rad(90)), -sin(ship.get_rot() + deg2rad(90)))
			var in_range = Vector2(ship.get_pos() - thing.get_pos()).dot(direction)
			if in_range >= .8:
				if not ship.owner.race in thing.get_groups() and not 'projectiles' in thing.get_groups():
					globals.comm.message(thing.name)
					fire()
					

func defend():
	var danger = false
	var what
	var things = ship.owner.ping_objects
	for thing in things:
		if Vector2(ship.get_pos() - thing.get_pos()).length() < 160:
			if thing == ship or (ship.owner.race in thing.get_groups() \
			and 'station_defense' in thing.get_groups()) \
			or ('projectiles' in thing.get_groups() and ship.owner.race in thing.owner.get_groups()):
				danger = false
			else:
				what = thing.name
				danger = true
	if danger:
		globals.comm.message('defending against: ' + what)
		if ship.engage == true:
			ship.engage = false
		shields()
	else:
		ship.shields_up = false


func check_for_nearest(entity, type, in_range):
	var type_saught
	if type == 'resource' or type == 'item':
		type_saught = globals.ping_areas
	elif type == 'ship' or type == 'asteroid':
		type_saught = globals.ping_objects
	
	var nearest_thing_distance = 1025
	for thing in type_saught:
		if entity in thing.get_groups():
			var thing_distance = Vector2(thing.get_pos() - ship.get_pos()).length()
			if thing_distance < nearest_thing_distance and thing_distance <= in_range:
				nearest_thing_distance = thing_distance
				closest_thing = thing


#!-----FUNCTIONS TO PASS TO SHIP-----!
func rotate():
	rotate = ship.get_pos().angle_to_point(aim)
	get_parent().rotate = rotate


func idle():
	ship.engage = false
	ship.brake = false


func accelerate():
	ship.brake = false
	if not ship.shields_up:
		ship.engage = true


func decelerate():
	ship.engage = false
	if ship.speed > .01:
		ship.brake = true



func fire():
	if not ship.shields_up:
		ship.fire = true


func shields():
	if not ship.engage:
		ship.shields_up = true


func shields_down():
	ship.shields_up = false
	