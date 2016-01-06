#need to fix
extends Node2D

var main_viewport
var texture
var pings
var ping_holder
var radar_bg
var radar_background 
var radar_area = 5
var blip
var globals
var player


func _ready():
	blip = preload('res://gui/mini_map_sprites.scn')
	globals = get_node("/root/globals")
	player = get_node("/root/player")
	radar_bg = get_node("Viewport/mini_map_bg")
#	radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
	ping_holder = get_node("Viewport/ping_holder")
	set_process(true)


func _process(delta):
	#10 is a magic number because I can't get the size of a collision shape
	#in order to get a ratio between the size of the shape and the size of the background
	if radar_area != 12 * player.scale.x:
		radar_background = radar_bg.get_texture().get_size() * radar_bg.get_transform().get_scale()
		radar_area = 12 * player.scale.x
#	#get pings from mini_map_tracker
	pings = globals.ping_areas
	pings += globals.ping_objects
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
		if ping == null or ('name' in ping and ping.name == 'cursor'):
			pings.erase(ping)
		else:
			var scale = Vector2(.34, .34)
			var rect_pos = Vector2(0, 0)
			var dot = blip.instance()
			#determines shape and size
			if 'resource' in ping.get_groups():
				rect_pos.y = 24
				scale.x = 4
				scale.y = 4
			elif 'object' in ping.get_groups():
				rect_pos.y = 12
				if 'asteroids' in ping.get_groups():
					scale *= (ping.size + 1)
			else:
				rect_pos.y = 0
				if 'ships' in ping.get_groups():
					scale *= (ping.size + 1) + 1 / (ping.size + 1)
				elif 'projectiles' in ping.get_groups():
					scale /= 2
			#determine's color
			if 'terran' in ping.get_groups():
				rect_pos.x = 36
			elif 'urthrax' in ping.get_groups():
				rect_pos.x = 24
			elif 'chentia' in ping.get_groups():
				rect_pos.x = 12
			else:
				rect_pos.x = 0
			#checks if it should rotate the dot image
			if 'entity' in ping.get_groups() and not 'object' in  ping.get_groups() and not 'projectiles' in ping.get_groups():
				if 'owner' in ping and ping.owner.name == 'player':
					dot.set_pos(Vector2(0, 0))
					dot.set_rot(player.rotate)
			else:
			 	pass
			#sets and adds dot
			dot.set_region_rect(Rect2(rect_pos, Vector2(12, 12)))
			dot.set_scale(scale)
			dot.set_pos((ping.get_pos() - player.get_pos()) / radar_area)
			ping_holder.add_child(dot)

func free_pings():
	#deletes earlier ping sprites
	if ping_holder.get_child_count() != 0:
		for child in range(0, ping_holder.get_child_count()):
			ping_holder.get_child(child).queue_free()