
extends RigidBody2D

var name
var race
var type
var status = 'normal'
var max_health
var health = 0 setget change_health
var max_energy
var energy = 0 setget change_energy

var shape_hit
var shield_index
var shield_strength
var credit = {}
var impacts = {}


func change_health(action, value):
	if action == 'add':
		if health + value <= max_health:
			health += value
		else:
			health = max_health
	elif action == 'subtract':
		if health - value >= 0:
			health -= value
		else:
			health = 0
	elif action == 'set':
		if value >= 0 and value >= max_health:
			health = value


func change_energy(action, value):
	if action == 'add':
		if energy + value <= max_energy:
			energy += value
		else:
			energy = max_energy
	elif action == 'subtract':
		if energy - value >= 0:
			energy -= value
		else:
			energy = 0
	elif action == 'set':
		if value >= 0 and value >= max_energy:
			energy = value

func _ready():

	set_process(true)
	
	
func _process(delta):
	#slowly regenerate energy "from neutrino collectors"
	if max_energy > 0 and energy < max_energy:
		energy += .0001


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
	var culprit
	var reward = health
	var hit = 0
	if at == 0:
		shape = 'hull'
	elif at == shield_index:
		shape = 'shield'
		
	if obj.type == 'projectile':
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
		if obj.type == 'projectile':
			culprit = obj.owner
#			obj.owner.reward(int(reward))
		else:
			culprit = obj
#			obj.reward(reward)
	if culprit != null:
		if not culprit.name in credit:
			credit[culprit.name] = {'who':culprit, 'gets':reward}
			
		else:
			credit[culprit.name].gets += reward

