
extends Node2D
var map_size
var outer
var outer_adj
var inner
var inner_adj
var pos_adj
var object_types = {}
var objects = []


func move_bg():
	var pos = get_parent().get_node("Player").get_pos()
	inner.set_pos(-pos / inner_adj + pos_adj)
	outer.set_pos(-pos / outer_adj + pos_adj)
	

func _process(delta):
	move_bg()
	
	
func _ready():
	object_types['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	map_size = get_node("area_map").get_item_rect()
	
	outer = get_node("BG/Outer_space")
	#try texture.get_size * texture.get_transform.get_scale() - tried it, did not work as suggested.
#	outer_adj = map_size.size.length() / Vector2(outer.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	outer_adj = map_size.size.length() / sqrt(pow((outer.get_child(0).get_texture().get_size().width * outer.get_child(0).get_transform().get_scale().x), 2) + pow((outer.get_child(0).get_texture().get_size().height * outer.get_child(0).get_transform().get_scale().y), 2))
	
	inner = get_node("BG/Inner_space")
#	inner_adj = map_size.size.length() / Vector2(inner.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	inner_adj = map_size.size.length() / sqrt(pow((inner.get_child(0).get_texture().get_size().width * inner.get_child(0).get_transform().get_scale().x), 2) + pow((inner.get_child(0).get_texture().get_size().height * inner.get_child(0).get_transform().get_scale().y), 2))
	
	pos_adj = Vector2(\
	get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2)
	populate()
	set_process(true)


func populate():
	var population = int(sqrt(map_size.size.length() / 10))
	print(population)
	for each in range(population):
		var info = {}
		var material
		var material_seed = int(rand_range(0, 3))
		info['size'] = int(rand_range(0, 3))
		info['shape'] = int(rand_range(0, 3))
		if material_seed == 0:
			material = 'normal'
		elif material_seed == 1:
			material = 'solid'
		else:
			material = 'ore'
		info['material'] = material
		info['name'] = each
		add_obj(info)

func add_obj(info):
	var entity
	if info.size == 0:
		entity = object_types.small_roid.instance()
	elif info.size == 1:
		entity = object_types.med_roid.instance()
	else:
		entity = object_types.large_roid.instance()
	entity.set_pos(rand_pos(entity.get_child(0).get_region_rect().size))
	entity.material = info.material
	entity.shape = info.shape
	entity.set_name(entity.get_name() + ' ' + str(info.name))

	add_child(entity)
#	objects.append(entity)
	

	
func rand_pos(obj_size):
	var ojects = get_tree().get_nodes_in_group('object')
	var valid = false
	var pos = Vector2(0, 0)
	while not valid:
		pos.x = rand_range(-map_size.size.width / 2 + obj_size.width, map_size.size.width / 4 - obj_size.width / 2)
		pos.y = rand_range(-map_size.size.height / 2 + obj_size.height, map_size.size.height / 4 - obj_size.height / 2)
		for obj in objects:
			if obj.get_type() == 'RigidBody2D' and obj.get_name() != 'player':
				if Vector2(pos - obj_size).length() > obj_size.length() * 1.5:
					valid = true
				else:
					valid = false
			else:
				if Vector2(pos - obj.get_item_rect.size * 2).length() > Vector2(obj.get_item_rect().size * 2).length():
					valid = true
				else:
					valid = false
		return pos

