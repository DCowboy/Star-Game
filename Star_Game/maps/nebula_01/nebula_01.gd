
extends Node2D
var map_size
var outer
var outer_adj
var inner
var inner_adj
var pos_adj
var population
var globals
	
	
func _process(delta):
	#moves background layers to correspond with player position creating a distance illusion
	var pos = globals.player_pos
	inner.set_pos(-pos / inner_adj + pos_adj)
	outer.set_pos(-pos / outer_adj + pos_adj)
	
	if globals.population < population / 4:
		globals.populate()
		print('repopulating')
	
func _ready():
	globals = get_node("/root/globals")
	population = globals.population
	globals.current_map = self
	globals.map_name = get_name()
	map_size = get_node("area_map").map_size
	globals.map_size = map_size
	
	#gets outer and inner space layers and their scale compared to the main play area (finally simplified some)
	outer = get_node("BG/Outer_space")
	var outer_texture_size = outer.get_node("star_bg").get_texture().get_size()
	var outer_transform_scale = outer.get_node("star_bg").get_transform().get_scale()
	outer_adj = map_size.size.length() / Vector2(outer_texture_size * outer_transform_scale).length()
	inner = get_node("BG/Inner_space")
	var inner_texture_size = inner.get_node("floating_stars").get_texture().get_size()
	var inner_transform_scale = inner.get_node("floating_stars").get_transform().get_scale()
	inner_adj = map_size.size.length() / Vector2(inner.get_child(0).get_texture().get_size() * inner.get_child(0).get_transform().get_scale()).length()
	
	pos_adj = Vector2(get_viewport_rect().size.width / 2, get_viewport_rect().size.height / 2)
	set_process(true)


