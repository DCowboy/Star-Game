#displays minimap
extends Node2D

var main_viewport
var texture
var ping_objects
var ping_areas
var radar_bg
var radar_background 
var radar_area
var globals
var player


func _ready():
	globals = get_node("/root/globals")
#	player = get_node("/root/player")
	radar_bg = get_node("Viewport/mini_map_bg")
	radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
	radar_area = 10
	set_process(true)


func _process(delta):
	if radar_area != 10 * globals.player_scale.x:
		radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
		radar_area = 10 * globals.player_scale.x
		print(radar_area)
#	#get pings from mini_map_tracker
	ping_objects = globals.ping_objects
	#add pings
	get_pings()
	#capture picture from viewport
	texture = get_node("Viewport").get_render_target_texture()
	#displays picture to minimap
	get_node("display").set_texture(texture)
	
	
func get_pings():
	#deletes earlier ping sprites
	var ping_holder = get_node("Viewport/ping_holder")
	if ping_holder.get_child_count() != 0:
		for child in range(0, ping_holder.get_child_count()):
			ping_holder.get_child(child).queue_free()
		
	#adds a spite for each ping
	for ping in ping_objects:
		if ping != null:
			var dot = globals.mini_map_icons.instance()
			dot.set_scale(Vector2(.5, .5))
			dot.set_pos(((ping.get_pos() - globals.player_pos)) / radar_area)
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
						dot.set_rot(globals.rotate)
			ping_holder.add_child(dot)
	