
extends RigidBody2D

const type = 'shield'
var name = 'urthrax station defense'
var max_health
var health
var max_energy
var energy
var exemptions = []
var shield_strength
var shape_hit
var shield_index
var credit = {}
var impacts = {}
var owner
var allies


func _ready():
	owner = get_node("/root/globals").terran_base
	max_health = 50 * owner.core
	health = max_health
	max_energy = 50 * owner.engineering
	energy = max_energy

	print('fully loaded at: ' + str(get_pos()))
	set_fixed_process(true)


func _fixed_process(delta):
	set_rot(get_rot() + 1 * delta)
	get_node("shield").set_rot(-get_rot())
	if energy < max_energy:
		energy += owner.engineering * pow(delta, 2)
	allies = get_tree().get_nodes_in_group('terran')
	# cleanup orphan exemptions
	for object in exemptions:
		if object == null:
			exemptions.erase(object)
	#check for additons to exemptions
	for object in allies:
		var id = object.get_rid()
		if object and not object in exemptions:
			PS2D.body_add_collision_exception(id, get_rid())
			exemptions.append(object)
	

func _integrate_forces(state):
	var count = state.get_contact_count()
	if count > 0:
		var collider = state.get_contact_collider_object(0)
		shape_hit = state.get_contact_local_shape(0)
		if not collider in impacts:
			impacts[collider] = 0
			hit_by(collider, shape_hit)


	
	
func hit_by(obj, shape):
	
	pass
	
	
func death():

	pass
