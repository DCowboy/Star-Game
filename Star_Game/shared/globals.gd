
extends Node2D

var main_viewport
var map_size

var player
var rotate
var player_pos
var mini_map_icons
var object_types = {}
var projectile_types = {}
var explosions = {}

var pings

func _ready():
	object_types['small_roid'] = preload('res://npcs/asteroids/small_asteroid.scn')
	object_types['med_roid'] = preload('res://npcs/asteroids/medium_asteroid.scn')
	object_types['large_roid'] = preload('res://npcs/asteroids/large_asteroid.scn')
	mini_map_icons = preload('res://gui/mini_map_sprites.scn')
	explosions['small_rock'] = preload('res://npcs/asteroids/small_asteroid_destroy.scn')
	explosions['med_rock'] = preload('res://npcs/asteroids/medium_asteroid_destroy.scn')
	explosions['large_rock'] = preload('res://npcs/asteroids/large_asteroid_destroy.scn')
	explosions['small_normal'] = preload('res://shared/small_explosion.scn')
	explosions['med_normal'] = preload('res://shared/medium_explosion.scn')
	explosions['large_normal'] = preload('res://shared/large_explosion.scn')
	projectile_types['small_laser'] = preload('res://npcs/projectiles/laser_shot.scn')
	main_viewport = get_viewport_rect()
