#need to fix
extends Area2D

var name = 'terran_base'
var engineering = 13
var weapons = 10
var core = 8
var globals
var in_terran_airspace = []
var already_known = []
var defender
var allies

func _ready():
	globals = get_node("/root/globals")
	globals.terran_base = self
	defender = get_parent().get_child(get_parent().get_child_count() -1)
	set_process(true)
	
	
func _process(delta):
	allies = get_tree().get_nodes_in_group('terran')
	in_terran_airspace = get_overlapping_bodies()
	for object in in_terran_airspace:
		if not object in already_known and not 'projectiles' in object.get_groups():
			if 'projectiles' in object.get_groups() or 'asteroids' in object.get_groups():
				pass
			else:
				var contact = ''
				if object in allies or ('owner' in object and object.owner in allies):
					contact = 'welcomed'
				else:
					contact = 'warned'
				print(contact + ' ' + object.name)
			already_known.append(object)
			
	
	var closest_object
	var shortest_distance = 1025
	for object in already_known:
		if not object in in_terran_airspace:
			already_known.erase(object)
		elif not object in allies and not 'projectiles' in object.get_groups():
			var distance = Vector2(object.get_pos() - get_pos()).length()
			if distance < shortest_distance:
				shortest_distance = distance
				closest_object = object
	defender.target = closest_object

