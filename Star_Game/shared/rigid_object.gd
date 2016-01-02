#need to fix
extends RigidBody2D

var name
#var race
#var type
var condition = 'normal'
var size = 0
var max_health = 1
var health = 1 setget change_health
var max_energy = 1
var energy = 1 setget change_energy
var shield_strength
var shape_hit
var shield_index
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
	health = max_health
	energy = max_energy
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
		for obj in impacts:
			if obj in self.get_colliding_bodies():
				impacts[obj] += 1
				if impacts[obj] == 45:
					hit_by(obj, shape_hit)
					impacts[obj] = 0
			else:
				impacts.erase(obj)
			


func hit_by(obj, at=null):
	var shape
	var culprit
	var reward = health
	var hit = 0
	if at == 0:
		shape = 'hull'
	elif at == shield_index:
		shape = 'shield'
		
	if 'projectiles' in obj.get_groups():
		hit = obj.payload
		set_applied_force(obj.direction * (obj.acceleration + obj.payload))
	else:
		hit = obj.get_mass()
	if shape == 'shield':
		energy -= hit / self.shield_strength
		if energy < 0:
			health += energy
			energy = 0
	else:
		health -= hit
		
	if health <= 0:
		health = 0
	if health < reward:
		reward -= health
		if 'projectiles' in obj.get_groups():
			culprit = obj.owner
		else:
			culprit = obj
	if culprit != null:
		if not culprit.name in credit:
			credit[culprit.name] = {'who':culprit, 'gets':reward}
			
		else:
			credit[culprit.name].gets += reward

