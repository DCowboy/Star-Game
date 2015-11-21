
extends Node2D

var main_viewport
var basis_viewport

var current_map
var map_size

var player
var rotate
var player_pos
var mini_map_icons
var object_types = {}
var projectile_types = {}
var explosions = {}

var pings

func _ready():
	basis_viewport = Rect2(0, 0, 800, 600)
	object_types['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	mini_map_icons = preload('res://gui/mini_map_sprites.scn')
	explosions['small_rock'] = preload('res://npcs/asteroids/small_asteroid_destroy.scn')
	explosions['med_rock'] = preload('res://npcs/asteroids/medium_asteroid_destroy.scn')
	explosions['large_rock'] = preload('res://npcs/asteroids/large_asteroid_destroy.scn')
	explosions['small_normal'] = preload('res://shared/small_explosion.scn')
	explosions['med_normal'] = preload('res://shared/medium_explosion.scn')
	explosions['large_normal'] = preload('res://shared/large_explosion.scn')
	projectile_types['small_laser'] = preload('res://npcs/projectiles/laser_shot.scn')
	main_viewport = get_viewport_rect()


func full_populate():
	#randomly populate the map
	var to_add = {}
	var data = {}
	var population = int(sqrt(map_size.size.length() / 20))
	for each in range(population):
		var info = {}
		var name
		info['parent'] = current_map
		info['type'] = '_roid'
		if info.type == '_roid':
			var modifier = ['small', 'med', 'large']
			info['size'] = int(rand_range(0, 3))
			info['modifier'] = modifier[info.size]
			info['material'] = int(rand_range(0, 3))
			info['shape'] = int(rand_range(0, 3))
			name = info.modifier + info.type + str(info.material) + str(info.shape)
		data['description'] = info
		
		if name in to_add:
			to_add[name].number += 1
			print('added one for total: ' + str(to_add[name].number))
		else:
			data['number'] = 1
			to_add[name] = data
	
	for each in to_add:
		add_entity(to_add[each].description, to_add[each].number)


func add_entity(description, number):
	#add certain number of a specific entity to a specific parent
	for each in range(number):
		var entity = object_types[description.modifier + description.type].instance()
		if description.type == '_roid':
			entity.size = description.size
			entity.material = description.material
			entity.shape = description.shape
		entity.set_name(entity.get_type() + "_" + str(number))
		entity.set_pos(rand_pos(entity.get_item_rect()))
		current_map.add_child(entity)
		entity.add_to_group('target', true)

	

func rand_pos(obj_size):
	#get a random position not too close to the player
	var valid = false
	var pos = Vector2(0, 0)
	while not valid:
		pos.x = rand_range(-map_size.size.width / 2 + obj_size.size.width, map_size.size.width / 2 - obj_size.size.width / 2)
		pos.y = rand_range(-map_size.size.height / 2 + obj_size.size.height, map_size.size.height / 2 - obj_size.size.height / 2)
		if Vector2(player_pos - obj_size.size).length() > 100:  #obj_size.size.length() * 5:
			valid = true
		else:
			valid = false

	return pos