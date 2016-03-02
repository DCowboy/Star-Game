#need to fix
extends Node2D

var ship
var tactical = 0 setget tactical_update
var tactical_upgrades = {}
var operations = 0 setget operations_update
var operations_upgrades = {}
var engineering = 0 setget engineering_update
var engineering_upgrades = {}
var armaments = {} #armaments: payload(tactical), speed(engineering * 1/3), range(ops * 2/3)
var navigation = {} #navigation: turning(ops), speed(eng * 2/3), braking(tact * 1/3)
var supply = {} #supply: range(ops),  quickness(engineering * 2/3), quality(tactical ^ 1/3) 
var hull_strength = 0 




func _ready():


	set_process(true)
	
	
func _process(delta):

	pass


func tactical_update():

	pass
	

	