#need to fix
extends Node2D

var main_viewport
var texture
var pings
var ping_holder
var radar_bg
var radar_background 
var radar_area
var blip
var globals
#var player


func _ready():
	blip = preload('res://gui/mini_map_sprites.scn')
	globals = get_node("/root/globals")
#	player = get_node("/root/player")
	radar_bg = get_node("Viewport/mini_map_bg")
	radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
	radar_area = 10
	ping_holder = get_node("Viewport/ping_holder")
	set_process(true)


func _process(delta):
	if radar_area != 10 * globals.player_scale.x:
		radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
		radar_area = 10 * globals.player_scale.x
		print(radar_area)
#	#get pings from mini_map_tracker
	pings = globals.ping_objects
	pings += globals.ping_areas
	#clear pings
	free_pings()
	#add pings
	get_pings()
	#capture picture from viewport
	texture = get_node("Viewport").get_render_target_texture()
	#displays picture to minimap
	get_node("display").set_texture(texture)
	
	
func get_pings():
	#adds a spite for each ping
	for ping in pings:
		if ping != null:
			var scale = Vector2(.3333, .3333)
			var rect_pos = Vector2(0, 0)
			var dot = blip.instance()
			
			if ping in get_tree().get_nodes_in_group('resource'):
				rect_pos.y = 24
				scale.x = 1
				scale.y = 1
			elif ping in get_tree().get_nodes_in_group('object'):
				rect_pos.y = 12
				if ping in get_tree().get_nodes_in_group('asteroids'):
					scale *= (ping.size + 1)
			else:
				rect_pos.y = 0
				if ping in get_tree().get_nodes_in_group('ships'):
					scale *= (ping.size + 1)
				
			if ping in get_tree().get_nodes_in_group('terran'):
				rect_pos.x = 36
			elif ping in get_tree().get_nodes_in_group('urthrax'):
				rect_pos.x = 24
			elif ping in get_tree().get_nodes_in_group('chentia'):
				rect_pos.x = 12
			else:
				rect_pos.x = 0

			if not ping in get_tree().get_nodes_in_group('object') and 'name' in ping and ping.name != 'laser_shot':
#				scale.x = 1
#				scale.y = 1
				if 'owner' in ping and ping.owner == 'player':
					dot.set_pos(Vector2(0, 0))
					dot.set_rot(globals.rotate)
			else:
			 	pass
			
			dot.set_region_rect(Rect2(rect_pos, Vector2(12, 12)))
			dot.set_scale(scale)
			dot.set_pos(((ping.get_pos() - globals.player_pos)) / radar_area)
			ping_holder.add_child(dot)

func free_pings():
	#deletes earlier ping sprites
	if ping_holder.get_child_count() != 0:
		for child in range(0, ping_holder.get_child_count()):
			ping_holder.get_child(child).queue_free()