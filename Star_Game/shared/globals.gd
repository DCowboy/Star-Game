
extends Node2D

var main_viewport
var map_size

var player
var rotate
var player_pos
var mini_map_icons
var object_types = {}
var projectile_types = {}

var pings

func _ready():
	object_types['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	mini_map_icons = preload('res://gui/mini_map_sprites.scn')
	projectile_types['small_laser'] = preload('res://npcs/projectiles/laser_shot.scn')
	main_viewport = get_viewport_rect()
#	map_size = get_node("client/nebula_1/area_map").map_size
#	player = get_node("client/Player")
#	set_process(true)
#	
#
#func _process(delta):
#	rotate = player.rotate
#	player_pos = player.get_pos()