
extends RigidBody2D

const type = 'shield'
const shield_range = 512
const warning_range = 1024
var name = 'urthrax station defense'
var max_health
var health
var max_energy
var energy
var exemptions = []
var shield_strength
var shield
var shield_alpha = 0
var shape_hit
var shield_index
var credit = {}
var impacts = {}
var owner
var allies
var closest_object
var globals


func _ready():
	globals = get_node("/root/globals")
	owner = globals.terran_base
	max_health = 50 * owner.core
	health = max_health
	max_energy = 50 * owner.engineering
	energy = max_energy
	shield = get_node("shield")
	shield.set_material(shield.get_material().duplicate(true))
	shield.get_material().set_shader_param("ratio", shield_alpha)
	set_fixed_process(true)


func _fixed_process(delta):
	set_rot(get_rot() + 1 * delta)
	shield.set_rot(-get_rot())
	if energy < max_energy:
		energy += owner.engineering * pow(delta, 2)
	allies = get_tree().get_nodes_in_group('urthrax')
	# cleanup orphan exemptions
	for object in exemptions:
		if object == null:
			exemptions.erase(object)
	#check for additons to exemptions
	for object in allies:
		if object == null:
			allies.erase(object)
		elif not object in exemptions and not 'item' in object.get_groups() and not 'resource' in object.get_groups():
				var obj_id = object.get_rid()
				var self_id = get_rid()
				PS2D.body_add_collision_exception(obj_id, self_id)
				exemptions.append(object)
				
	var closest_pos = Vector2(0, 0)
	var closest_distance = 1025
	
	if closest_object:
		closest_pos = closest_object.get_pos()
		closest_distance = Vector2(closest_pos - get_pos()).length()
	elif shield_alpha > 0:
		shield_alpha -= 1 - delta
		
	if closest_distance <= warning_range:
		shield_alpha = abs(warning_range - Vector2(closest_pos - get_pos()).length())
	else:
		shield_alpha -= 1 - delta
	
		
	var ratio = shield_alpha / (warning_range - shield_range)
	if ratio > 1:
		if self.is_hidden():
			show()
		ratio = 1
	shield.get_material().set_shader_param("ratio", ratio)
		

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
