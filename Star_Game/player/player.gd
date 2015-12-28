#need to fix
extends Node2D

var name = 'player'
var race
var ships = []
var current_ship
var current_ship_status
var current_ship_cargo
var controls
var scale = Vector2(0, 0)
var pos #= Vector2(0, 0)
var speed = 0
var rotate

func _ready():
	race = 'terran'
	controls = preload('res://player/player_control.gd')
