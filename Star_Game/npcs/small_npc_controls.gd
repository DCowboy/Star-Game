
extends Node2D

var globals
var name
var rotate = 0
var ship = null
var closest_area = null
var closest_object = null
var direction
var aim
var is_turning = false
var is_thrusting = false
var is_braking = false
var is_shielding = false
var main_target = null
var main_target_location = Vector2(0, 0)
var secondary_target = null
var mode = 'scouting'
var needs = {}
var objectives = {}
var current_action = null
var next_action = null
var health_ratio
var energy_ratio


func _ready():
	globals = get_node("/root/globals")
	name = 'small_npc_controls'
	rotate = get_parent().rotate
	set_process(true)


func _process(delta):
	#gather information
	check_needs()
	#make choices
	make_choices()
	
	#act
	
	
func check_objectives():
	
	pass


func check_needs():
	health_ratio = ship.health / ship.max_health
	energy_ratio = ship.energy / ship.max_energy
	check_priority('health')
	check_priority('energy')
	
	
func check_priority(need):
	if need < .25:
		needs[need] = 1
	elif need < .5:
		needs[need] = 2
	elif health_ratio < .75:
		needs[need] = 3
	else:
		if need in needs:
			needs.erase(need)
	

func make_choices():
	
	pass


func search_for_nearest(place_or_item, in_range):
	var areas = globals.ping_areas
	
	var closest_area_distance = 1025
	for area in areas:
		if place_or_item in area.get_groups():
			var area_distance = Vector2(area.get_pos() - ship.get_pos()).length()
			if area_distance < closest_area_distance and area_distance <= in_range:
				closest_area_distance = area_distance
				closest_area = area

func search_for_closest(thing, in_range):
	var objects = globals.ping_objects
	
	var closest_object_distance = 1025
	for object in objects:
		if thing in object.get_groups():
			var object_distance = Vector2(object.get_pos() - ship.get_pos()).length()
			if object_distance < closest_object_distance and object_distance <= in_range:
				closest_object_distance = object_distance
				closest_object = object


func rotate(angle):
	rotate = angle
	print('rotate = ' + str(rotate))
	
	get_parent().rotate = rotate


func accelerate():
	if not ship.shields_up:
		ship.engage = true


func decelerate():
	ship.brake = true


func fire():
	if not ship.shields_up:
		ship.fire = true


func shields():
	if not ship.engage:
		ship.shields_up = true

func attach_to_ship():
	ship = get_parent().current_ship_instance.hull

	