
extends Node2D
var map_size
var outer
var outer_adj
var inner
var inner_adj
var pos_adj
var objects = []
	
	
func _process(delta):
	#moves background layers to correspond with player position creating a distance illusion
	var pos = get_parent().get_node("Player").get_pos()
	inner.set_pos(-pos / inner_adj + pos_adj)
	outer.set_pos(-pos / outer_adj + pos_adj)
	
	
func _ready():
	get_node("/root/globals").current_map = self
	map_size = get_node("area_map").map_size
	get_node("/root/globals").map_size = map_size
	
	outer = get_node("BG/Outer_space")
	#try texture.get_size * texture.get_transform.get_scale() - tried it, did not work as suggested.
#	outer_adj = map_size.size.length() / Vector2(outer.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	outer_adj = map_size.size.length() / sqrt(pow((outer.get_child(0).get_texture().get_size().width * outer.get_child(0).get_transform().get_scale().x), 2) + pow((outer.get_child(0).get_texture().get_size().height * outer.get_child(0).get_transform().get_scale().y), 2))
	
	inner = get_node("BG/Inner_space")
#	inner_adj = map_size.size.length() / Vector2(inner.get_child(0).get_texture().get_size() * outer.get_child(0).get_scale()).length()
	inner_adj = map_size.size.length() / sqrt(pow((inner.get_child(0).get_texture().get_size().width * inner.get_child(0).get_transform().get_scale().x), 2) + pow((inner.get_child(0).get_texture().get_size().height * inner.get_child(0).get_transform().get_scale().y), 2))
	
	pos_adj = Vector2(\
	get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2)
	
	get_node("/root/globals").player_pos = get_parent().get_node("Player").get_pos()
	get_node("/root/globals").full_populate()
	set_process(true)


