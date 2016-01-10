
extends Node2D

var globals
var name
var aim = Vector2(0, 0) #pseudo mouse cursor position
var rotate = 0
var ship = null
var closest_thing = null
var moving_direction 
var state = 'start'
var is_turning = false
var is_thrusting = false
var is_braking = false
var is_shielding = false
var main_target = null
var main_target_location = Vector2(0, 0)
var secondary_target = null
var mode = 'scout'
var needs = {}
var current_action = null
var next_action = null
var thinking = 0
var think_speed = 30

func _ready():
	globals = get_node("/root/globals")
	name = 'small_npc_controls'
	rotate = get_parent().rotate
	set_process(true)


func _process(delta):
	moving_direction = ship.get_rot()
	thinking += 1
	#gather information
	check_needs()
	#make choices
	make_choices()
	
	#act
	if thinking >= think_speed * 2:
		globals.comm.message(state)
		thinking = 0
	if state == 'move':
		move()
	elif state == 'turn':
		turn()
	elif state == 'brake':
		decelerate()
	elif state == 'shoot':
		fire()




func check_needs():
	var health_ratio = ship.health / ship.max_health
	var energy_ratio = ship.energy / ship.max_energy
	check_priority(health_ratio, 'health')
	check_priority(energy_ratio, 'energy')
	
	
func check_priority(check, need):
	if check < .25:
		needs[need] = 1
	elif check < .5:
		needs[need] = 2
	elif check < .75:
		needs[need] = 3
	else:
		if need in needs:
			needs.erase(need)
	

func make_choices():
	if not 'health' in needs:
		if state == 'start' or thinking >= think_speed:
			randomize()
			aim.x = rand_range(-1, 1)
			randomize()
			aim.y = rand_range(-1, 1)
			state = 'turn'
		else:
			state = 'move'

	else:
		aim = get_parent().home_station.get_pos()
		if Vector2(ship.get_pos() - get_parent().home_station.get_pos()).length() > 250:
			state = 'turn'
		else:
			if state == 'move':
				state = 'brake'
			else:
				state = ''
	pass


func search_for_nearest(entity, type, in_range):
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


func move():
	if  ship.speed < ship.top_speed:
		accelerate()




func turn():
	if thinking >= think_speed:
		globals.comm.message(str(moving_direction) + ' - ' + str(rotate))
	rotate()
	if ship.speed >= 100:
		state = 'brake'


#!-----FUNCTIONS TO PASS TO SHIP-----!
func rotate():
	rotate = ship.get_pos().angle_to_point(aim)
	get_parent().rotate = rotate


func accelerate():
	if not ship.shields_up:
		ship.engage = true
		ship.brake = false
		
		


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

func attach_to_ship():
	ship = get_parent().current_ship_instance.hull

	