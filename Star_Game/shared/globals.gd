
extends Node2D

var main_viewport
var basis_viewport
var true_scale
var square_scale

var current_map
var map_name
var map_size


var player
var rotate
var player_pos
var mini_map_icons


var object_types = {}
var explosions = {}
var sound_effects

var ping_objects
var ping_areas

func _ready():
	basis_viewport = Rect2(0, 0, 800, 600)
	object_types['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	object_types['player'] = preload('res://player/blue_battle_cruiser.scn')
	print('loaded object types')
	mini_map_icons = preload('res://gui/mini_map_sprites.scn')
	explosions['small_rock'] = preload('res://npcs/asteroids/small_asteroid_destroy.scn')
	explosions['med_rock'] = preload('res://npcs/asteroids/medium_asteroid_destroy.scn')
	explosions['large_rock'] = preload('res://npcs/asteroids/large_asteroid_destroy.scn')
	explosions['small_normal'] = preload('res://shared/small_explosion.scn')
	explosions['med_normal'] = preload('res://shared/medium_explosion.scn')
	explosions['large_normal'] = preload('res://shared/large_explosion.scn')
	print('loaded explosions and mini-map')
	sound_effects = preload('res://shared/sound_effects.scn')
	print('sounds')
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
		var entity = object_types[description.type].instance()
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
		if Vector2(player_pos - pos).length() > 100:  
			break

	return pos

