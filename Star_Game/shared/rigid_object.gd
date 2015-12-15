
extends RigidBody2D

var name
var race
var type
var max_health
var health 
var max_energy
var energy

var shape_hit
var shield_index
var shield_strength

var impacts = {}

func _ready():

	set_process(true)
	
	
func _process(delta):
	#slowly regenerate energy "from neutrino collectors"
	if max_energy > 0 and energy < max_energy:
		energy += .001


func _integrate_forces(state):
	var count = state.get_contact_count()
	if count > 0:
		var collider = state.get_contact_collider_object(0)
		shape_hit = state.get_contact_local_shape(0)
		if not collider in impacts:
			impacts[collider] = 0
			hit_by(collider, shape_hit)
		
	if impacts != null:
		for each in impacts:
			impacts[each] += 1
			if impacts[each] == 45:
				hit_by(each, shape_hit)
				impacts[each] = 0


func hit_by(obj, at=null):
	var shape
	var reward = health
	var hit = 0
	if at == 0:
		shape = 'hull'
	elif at == shield_index:
		shape = 'shield'
		
	if obj.name == 'laser_shot':
		hit = obj.payload
		set_applied_force(obj.direction * (obj.acceleration + obj.payload))
	elif 'material' in obj and 'material' in self:
		if obj.get_mass() > get_mass():
			health += (obj.get_mass() + get_mass()) / 2.5
		if health > max_health:
			health = max_health
	else:
		hit = obj.get_mass()
	if shape == 'shield':
		energy -= hit / shield_strength
		if energy < 0:
			health += energy
			energy = 0
	else:
		health -= hit
		
	if health <= 0:
		health = 0
	if health < reward:
		reward -= health
		if obj.name == 'laser_shot':
			obj.owner.reward(int(reward))
		else:
			obj.reward(reward)
			
			
func reward(amount):
	if name == 'Player':
		print('recieved reward of ' + str(amount))
		


