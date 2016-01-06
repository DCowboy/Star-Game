#need to fix
extends Area2D

var name = 'chentia_base'
var engineering = 8
var weapons = 13
var core = 10
var globals
var allies
var in_airspace
var visitors = []
var threats = []
var def_equip
var defender


func _ready():
	globals = get_node("/root/globals")
	globals.chentia_base = self
	def_equip = preload('res://maps/station_02_defense.scn')
	
	set_process(true)
	
	
func _process(delta):
	if defender == null:
		defender = def_equip.instance()
		defender.set_pos(get_pos())
		get_parent().add_child(defender)
		
	allies = get_tree().get_nodes_in_group('chentia')
	in_airspace = get_overlapping_bodies()
	for object in in_airspace:
		var contact = ''
		if object == self or 'station_defense' in object.get_groups():
			pass
		elif object in allies or ('owner' in object and object.owner in allies):
			if not object in visitors:
				if not 'projectiles' in object.get_groups():
					print(object.name + ' is player type? ' + str('player_type' in object.owner.get_groups()))
					contact = 'welcomed'
				visitors.append(object)
		else:
			if not object in threats:
				if not 'asteroids' in object.get_groups():
					contact = 'warned'
				threats.append(object)
		
		if contact != '':
			print(name + ' ' + contact + ' ' + object.name)
			
	#clean up threats[]
	for object in threats:
		if object == null or not 'name' in object:
			threats.erase(object)
			
	
	var closest_object
	var shortest_distance = 1025
	for object in threats:
		if not object in in_airspace:
			threats.erase(object)
		else:
			var distance = Vector2(object.get_pos() - get_pos()).length()
			if distance < shortest_distance:
				shortest_distance = distance
				closest_object = object
	defender.target = closest_object
	closest_object = null


