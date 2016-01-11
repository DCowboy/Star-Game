
extends Node2D

var globals
var name
var aim = Vector2(0, 0) #pseudo mouse cursor position
var rotate = 0
var move_speed # variable to tell ship how fast to go
var brake_to_speed = 0 # speed to brake to
var ship = null
var closest_thing = null
var moving_direction 
var mode = 'scout'
var behavior = ''
var previous_state = ''
var state = 'start'
var state_status
var needs = {}
var thinking = 0
var think_speed = 30 

func _ready():
	globals = get_node("/root/globals")
	name = 'small_npc_controls'
	rotate = get_parent().rotate
	set_process(true)


func _process(delta):
	if ship.brake == true:
		ship.engage = false
	if ship.engage == true:
		ship.brake = false
	if ship.health <= 0:
		state = 'start'
		move_speed = null
		state_status = ''
		mode = 'scout'
		previous_state = ''
		
	moving_direction = ship.get_rot()
	thinking += 1
	#gather information
	check_needs()
	#make choices
	make_choices()
	
	#act
	if state == 'move':
		move()
	elif state == 'still_turn':
		still_turn()
	elif state == 'braking_turn':
		braking_turn()
	elif state  == 'accelerating_turn':
		accelerating_turn()
	elif state == 'brake':
		brake()
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
	var current_state = state
	if 'health' in needs or ('energy' in needs and needs.energy <= 2):
		mode = 'return to base'
	else:
		mode = 'scout'
		
	if mode == 'scout':
		if state == 'start' or state == '':
			if str(state).find('turn') == -1:
				randomize()
				aim.x = rand_range(- globals.main_viewport.size.x / 2, globals.main_viewport.size.x / 2)
				randomize()
				aim.y = rand_range(- globals.main_viewport.size.y / 2, globals.main_viewport.size.y / 2)
			if state == 'start':
				state = 'still_turn'
			else:
				state = 'braking_turn'
		elif str(state).find('turn') != -1 and state_status == 'completed':
			randomize()
			move_speed = rand_range(0, ship.top_speed)
			state = 'move'
		elif state == 'move' and state_status == 'completed':
			if thinking >= think_speed:
				state = ''
		else:
			globals.comm.message(state)
#				brake_to_speed = 0
#				state = 'brake'
				
	elif mode == 'return to base':
		aim = get_parent().home_station.get_pos()
		if Vector2(get_parent().home_station.get_pos() - ship.get_pos()).length() > 250:
			if state.find('turn') and state_status == 'completed':
				move_speed = ship.top_speed
				state = 'move'
			else:
				state = 'braking_turn'
		else:
			if ship.speed > 0:
				state = 'brake'
			else:
				state = ''
	#moving
		
	if current_state != state:
		previous_state = current_state
		globals.comm.message(state)
	if thinking >= think_speed:
		globals.comm.message(str(needs) + ' ' + mode + ' ' + state)
		thinking = 0
	

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
	state_status = 'in progress'
	if  ship.speed < move_speed:
		if not ship.shields_up:
			ship.engage = true

	else:
		ship.engage = false
		state_status = 'completed'



func still_turn():
	state_status = 'in progress'
	if ship.speed > .01:
		ship.brake = true
	else:
		ship.brake = false
	if rotate != Vector2(0, 0).angle_to_point(aim):
		rotate = Vector2(0, 0).angle_to_point(aim)
		get_parent().rotate = rotate
	else:
		state_status = 'completed'
		
		
func brake():
	state_status = 'in progress'
	if ship.speed > brake_to_speed:
		ship.brake = true
	else:
		ship.brake = false
		state_status = 'completed'
		

func braking_turn():
	state_status = 'in progress'
	brake_to_speed = 100
	if ship.speed > brake_to_speed:
		ship.brake = true
	else:
		ship.brake = false
	if rotate == Vector2(0, 0).angle_to_point(aim):
		ship.brake = false
		state_status = 'completed'
	else:
		rotate = Vector2(0, 0).angle_to_point(aim)



func accelerating_turn():
	state_status = 'in progress'
	ship.engage = true
	if rotate != Vector2(0, 0).angle_to_point(aim):
		rotate = Vector2(0, 0).angle_to_point(aim)
		get_parent().rotate = rotate
	else:
		state_status = 'completed'


#!-----FUNCTIONS TO PASS TO SHIP-----!
#func rotate():
#	rotate = ship.get_pos().angle_to_point(aim)
#	get_parent().rotate = rotate
#	return


#func accelerate():
#	if not ship.shields_up:
#		ship.engage = true
#		ship.brake = false
		
		


#func decelerate():
#	ship.engage = false
#	if ship.speed > .01:
#		ship.brake = true
		


func fire():
	if not ship.shields_up:
		ship.fire = true


func shields():
	if not ship.engage:
		ship.shields_up = true

func attach_to_ship():
	ship = get_parent().current_ship_instance.hull

	