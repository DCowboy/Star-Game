#need to fix
extends Area2D

var name = 'chentia_base'
var race = 'Chentia'
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
		
	allies = get_tree().get_nodes_in_group(str(race).to_lower())
	in_airspace = get_overlapping_bodies()
	for object in in_airspace:
		var sender = '[color=#ff0000][b]' + name + ': [/b][/color]'
		var message
		var is_player = false
		var contact = ''
		if object == self or 'station_defense' in object.get_groups():
			pass
		elif object in allies or ('owner' in object and object.owner in allies):
			if not object in visitors:
				if not 'projectiles' in object.get_groups():
					print(object.name + ' is player type? ' + str('player_type' in object.owner.get_groups()))
					if 'player_type' in object.owner.get_groups():
						is_player = true
						message = 'You are now in ' + race + ' airspace. Welcome Home!'
						
					contact = 'welcome'
				visitors.append(object)
		else:
			if not object in threats:
				if not 'asteroids' in object.get_groups():
					if 'player_type' in object.owner.get_groups():
						is_player = true
						message = 'You are now in ' + race + ' airspace. Leave now if you value your life!'
					contact = 'warning'
				threats.append(object)
		
		if contact != '':
			if is_player:
				get_node("/root/globals").comm.message(sender + message)
			else:
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


