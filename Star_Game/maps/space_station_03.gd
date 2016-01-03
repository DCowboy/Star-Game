#need to fix
extends Area2D

var name = 'urthrax_base'
var engineering = 13
var weapons = 10
var core = 8
var globals
var in_airspace = []
var already_known = []
var def_equip
var defender
var allies


func _ready():
	globals = get_node("/root/globals")
	globals.urthrax_base = self
	def_equip = preload('res://maps/station_03_defense.scn')
	set_process(true)
	
	
func _process(delta):
	if defender == null:
		defender = def_equip.instance()
		defender.set_pos(get_pos())
		get_parent().add_child(defender)

	allies = get_tree().get_nodes_in_group('urthrax')
	in_airspace = get_overlapping_bodies()
	for object in in_airspace:
		if not object in already_known and not 'projectiles' in object.get_groups():
			if 'projectiles' in object.get_groups() or 'asteroids' in object.get_groups():
				pass
			else:
				var contact = ''
				if object in allies or ('owner' in object and object.owner in allies):
					contact = 'welcomed'
				else:
					contact = 'warned'
				print(self.name + ' ' + contact + ' ' + object.name)
			already_known.append(object)
	
	var closest_object
	var shortest_distance = 1025
	for object in already_known:
		if not object in in_airspace:
			already_known.erase(object)
		elif not object in allies and not 'projectiles' in object.get_groups():
			var distance = Vector2(object.get_pos() - get_pos()).length()
			if distance < shortest_distance:
				shortest_distance = distance
				closest_object = object
	defender.closest_object = closest_object
