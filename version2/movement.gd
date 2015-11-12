
extends Node2D
var map_size
var outer
var outer_adj
var inner
var inner_adj
var pos_adj


func move_bg():
	var pos = get_parent().get_node("Player").get_pos()
	inner.set_pos(-pos / inner_adj + pos_adj)
	outer.set_pos(-pos / outer_adj + pos_adj)
	

func _process(delta):
	move_bg()
	
	
func _ready():
	map_size = get_node("area_map").get_item_rect()
	
	outer = get_node("BG/Outer_space")
	outer_adj = sqrt(pow(map_size.size.width, 2) \
	+ pow(map_size.size.height, 2)) \
	/ sqrt(pow((outer.get_child(0).get_texture().\
	get_size().width * outer.get_child(0).\
	get_transform().get_scale().x) \
	, 2) + pow((outer.get_child(0).get_texture().\
	get_size().height * outer.get_child(0).\
	get_transform().get_scale().y), 2))

	inner = get_node("BG/Inner_space")
	inner_adj = sqrt(pow(map_size.size.width, 2) \
	+ pow(map_size.size.height, 2)) \
	/ sqrt(pow((inner.get_child(0).get_texture().\
	get_size().width * inner.get_child(0).\
	get_transform().get_scale().x) \
	, 2) + pow((inner.get_child(0).get_texture().\
	get_size().height * inner.get_child(0).\
	get_transform().get_scale().y), 2))

	pos_adj = Vector2(\
	get_viewport_rect().size.width / 2,\
	get_viewport_rect().size.height / 2)
	
	set_process(true)
