#need to fix
extends Node2D

var globals
var name
var race
var home_station
var ships = []
var current_ship
var current_ship_instance = {'hull': null, 'status': null, 'cargo': null}
var controls
var scale = Vector2(1, 1)
var speed = 0
var rotate

func _ready():
	globals = get_node("/root/globals")
	name = 'player'
	race = 'terran'
	controls = preload('res://player/player_control.gd').new()
	add_child(controls)
	set_process(true)
	

func _process(delta):
	if home_station == null:
		if race == 'terran':
			home_station = globals.terran_base
		elif race == 'chentia':
			home_station = globals.chentia_base
		elif race == 'urthrax':
			home_station = globals.urthrax_base
	if current_ship_instance.hull != null:
		if get_node("Camera2D").get_zoom() != scale:
			get_node("Camera2D").set_zoom(scale)