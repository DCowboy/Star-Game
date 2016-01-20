#need to fix
extends Node2D

var main_viewport
var basis_viewport
var true_scale
var square_scale
var movie_mode = false

var maps = {}
var current_map
var map_name
var map_size
var population = 0
var terran_base
var chentia_base
var urthrax_base

var asteroids = {}
var items = {}
var explosions = {}
var sound_effects
var cursor_frame = 0
var comm

var mini_map_size = Vector2(0, 0)


func _ready():

	maps['nebula_01'] = preload('res://maps/nebula_01/nebula_01.scn')

	basis_viewport = Rect2(0, 0, 800, 600)
	asteroids['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	asteroids['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	asteroids['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	
	items['energy_restore'] = preload('res://items/energy_restore.scn')
	items['ship_repair'] = preload('res://items/ship_repair.scn')
	
	explosions['small_rock'] = preload('res://npcs/asteroids/small_asteroid_destroy.scn')
	explosions['med_rock'] = preload('res://npcs/asteroids/medium_asteroid_destroy.scn')
	explosions['large_rock'] = preload('res://npcs/asteroids/large_asteroid_destroy.scn')
	explosions['small_normal'] = preload('res://shared/small_explosion.scn')
	explosions['med_normal'] = preload('res://shared/medium_explosion.scn')
	explosions['large_normal'] = preload('res://shared/large_explosion.scn')

	sound_effects = preload('res://shared/sound_effects.scn')

	main_viewport = get_viewport_rect()
	true_scale = Vector2(main_viewport.size / basis_viewport.size)
	square_scale = Vector2(main_viewport.size.width / basis_viewport.size.width, main_viewport.size.width / basis_viewport.size.width)


func full_populate():
	#randomly populate the map
	var to_add = {}

	var make = int(map_size.size.length() / 100)
	for each in range(make):
		var data = {}
		var info = {}
		var name
		var type
		info['parent'] = current_map
		type = '_roid'
		if type == '_roid':
			var modifier = ['small', 'med', 'large']
			info['size'] = int(rand_range(0, 3))
			info['type'] = modifier[info.size] + type
			info['material'] = int(rand_range(0, 3))
			info['shape'] = int(rand_range(0, 3))
			info['pos'] = null
			name = info.type + str(info.material) + str(info.shape)
		data['description'] = info
		
		if not name in to_add:
			data['number'] = 1
			to_add[name] = data
			
		else:
			to_add[name].number = to_add[name].number + 1
	for each in to_add:
		add_entity(to_add[each].description, to_add[each].number)


func add_entity(description, number):
	#add certain number of a specific entity to a specific parent
	for each in range(number):
		var entity = asteroids[description.type].instance()
		if str(description.type).find('_roid') != -1:
			entity.size = description.size
			entity.material = description.material
			entity.shape = description.shape
		if description.pos == null:
			entity.set_pos(rand_pos())
		else:
			entity.set_pos(description.pos)
		current_map.add_child(entity)


func rand_pos():
	#get a random position that won't kill any one on arrival
	var base_positions = [chentia_base.get_pos(), terran_base.get_pos(), urthrax_base.get_pos()]
	var ship_positions = []
	var pos = Vector2(0, 0)
	var valid = false
	for ship in get_tree().get_nodes_in_group('ships'):
		ship_positions.append(ship.get_pos())
	while not valid:
		randomize()
		pos.x = rand_range(-map_size.size.width * .4, map_size.size.width * .4)
		pos.y = rand_range(-map_size.size.height * .4, map_size.size.height * .4)
		valid = true
		for base_pos in base_positions:
			if Vector2(pos - base_pos).length() < 500:
				valid = false
		for ship_pos in ship_positions:
			if Vector2(pos - ship_pos).length() < 250:
				valid = false
				
	return pos

