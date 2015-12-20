
extends Node2D

var main_viewport
var basis_viewport
var true_scale
var square_scale

var maps = {}
var current_map
var map_name
var map_size

var ships = {}
var terran_base

var player = {'ship':null, 'status':null}
var player_scale
var rotate
var player_speed = 0
var player_pos
var player_race
var mini_map_icons


var asteroids = {}
var items = {}
var explosions = {}
var sound_effects

var ping_objects
var ping_areas

func _ready():
	maps['nebula_01'] = preload('res://maps/nebula_01/nebula_01.scn')
	ships['terran_corvette'] = {'scene': preload('res://player/terran_corvette.scn'), 'status': preload('res://player/terran_corvette_status.scn')}
	ships['terran_warship'] = {'scene': preload('res://player/terran_warship.scn'), 'status': preload('res://player/terran_warship_status.scn')}
#	player['cargo'] =
	basis_viewport = Rect2(0, 0, 800, 600)
	asteroids['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	asteroids['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	asteroids['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	
	items['energy_restore'] = preload('res://items/energy_restore.scn')
	items['ship_repair'] = preload('res://items/ship_repair.scn')

	mini_map_icons = preload('res://gui/mini_map_sprites.scn')
	
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

	var population = int(map_size.size.length() / 100)
	for each in range(population):
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
		entity.add_to_group('target', true)


func rand_pos():
	#get a random position not too close to the player
	var broken = false
	var pos = Vector2(0, 0)
	while not broken:
		randomize()
		pos.x = rand_range(-map_size.size.width * .4, map_size.size.width * .4)
		pos.y = rand_range(-map_size.size.height * .4, map_size.size.height * .4)
		if Vector2(player_pos - pos).length() > 500:  
			break

	return pos

