#displays minimap
extends Node

var main_viewport
var texture
var ping_objects
var ping_areas


func _ready():
	#sets minimap to a size based upon the viewport size
	main_viewport = get_node("/root/globals").main_viewport
	get_node("Viewport").set_rect(Rect2(Vector2(0, 0), Vector2(main_viewport.size.width, main_viewport.size.width) / 4))
	get_node("Viewport/mini_map_bg").set_scale(get_node("/root/globals").square_scale)
	get_node("display").set_size(get_node("Viewport/mini_map_bg").get_texture().get_size())
	get_node("display").set_pos(Vector2(main_viewport.size.width * .75, 0))

	set_process(true)


func _process(delta):
	#get pings from mini_map_tracker
	ping_objects = get_node("/root/globals").ping_objects
	#add pings
	get_pings()
	#capture picture from viewport
	texture = get_node("Viewport").get_render_target_texture()
	#displays picture to minimap
	get_node("display").set_texture(texture)
	
	
func get_pings():
	#deletes earlier ping sprites
	if get_node("Viewport/ping_holder").get_child_count() != 0:
		for child in range(0, get_node("Viewport/ping_holder").get_child_count()):
			get_node("Viewport/ping_holder").get_child(child).queue_free()
		
	#adds a spite for each ping
	for ping in ping_objects:
		var dot = get_node("/root/globals").mini_map_icons.instance()
		dot.set_scale(Vector2(.5, .5))
		dot.set_pos(((ping.get_pos() + Vector2(0, 100) - get_node("/root/globals").player_pos)) / 12)
		if ping in get_tree().get_nodes_in_group('friendly'):
			dot.set_region_rect(Rect2(8, 0, 8, 8))
		if ping in get_tree().get_nodes_in_group('target'):
			dot.set_region_rect(Rect2(16, 0, 8, 8))
		else:
			if ping.name != 'laser_shot':
				dot.set_region_rect(Rect2(0, 0, 8, 8))
				dot.set_scale(Vector2(1,1))
				if ping.name == 'Player':
					dot.set_pos(Vector2(0, 0))
					dot.set_rot(get_node("/root/globals").rotate)
		get_node("Viewport/ping_holder").add_child(dot)
	