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


