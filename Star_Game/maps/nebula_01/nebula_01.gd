
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
	object_types['small_roid'] = load('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = load('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = load('res://npcs/asteroids/large_asteroid.scn')
	map_size = get_node("area_map").get_item_rect()
	
	outer = get_node("BG/Outer_space")
	#try texture.get_size * texture.get_transform.get_scale() - tried it, did not work as suggested.
#	outer_adj = map_size.size.length() / Vector2(outer.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	outer_adj = map_size.size.length() / sqrt(\
	pow((outer.get_child(0).get_texture().get_size().width * outer.get_child(0).get_transform().get_scale().x), 2) \
	+ pow((outer.get_child(0).get_texture().get_size().height * outer.get_child(0).get_transform().get_scale().y), 2))
	
	inner = get_node("BG/Inner_space")
#	inner_adj = map_size.size.length() / Vector2(inner.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	inner_adj = map_size.size.length() / sqrt(\
	pow((inner.get_child(0).get_texture().get_size().width * inner.get_child(0).get_transform().get_scale().x), 2) \
	+ pow((inner.get_child(0).get_texture().get_size().height * inner.get_child(0).get_transform().get_scale().y), 2))
	
	pos_adj = Vector2(\
	get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2)
	populate()
	set_process(true)


func populate():
	objects.append(object_types.small_roid.instance())
	objects[0].set_pos(Vector2(0, 0))
	objects[0].material = 'normal'
	objects[0].shape = 2
	add_child(objects[0])
	pass