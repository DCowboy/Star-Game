#need to fix
extends Area2D

var name = 'terran_base'
var race = 'Terran'
var engineering = 13
var weapons = 10
var core = 8
var globals
var allies
var in_airspace
var visitors = []
var threats = []
var def_equip
var defender



func _ready():
	globals = get_node("/root/globals")
	globals.terran_base = self
	def_equip = preload('res://maps/station_01_defense.scn')
	set_process(true)
	
	
func _process(delta):
	if defender == null:
		defender = def_equip.instance()
		defender.set_pos(get_pos())
		get_parent().add_child(defender)
		
	allies = get_tree().get_nodes_in_group(str(race).to_lower())
	in_airspace = get_overlapping_bodies()
	for object in in_airspace:
		var sender = '[color=#0000ff][b]' + name + ': [/b][/color]'
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
	
	var closest_object
	var next_closest_object
	var shortest_distance = 1025
	var next_shortest_distance = 1026
	for object in threats:
		if not object in in_airspace:
			threats.erase(object)
		else:
			var distance = Vector2(object.get_pos() - get_pos()).length()
			if distance < shortest_distance:
				if shortest_distance < next_shortest_distance:
					next_shortest_distance = shortest_distance
					next_closest_object = closest_object
				shortest_distance = distance
				closest_object = object
	defender.closest_object = closest_object
	defender.next_closest_object = next_closest_object

