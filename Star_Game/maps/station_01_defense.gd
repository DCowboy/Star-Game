
extends RigidBody2D

const type = 'cannon'
const fire_range = 512
const aim_range = 1024
var name = 'terran station defense'
var effect
var fire_delay = 0
var fire_rate = 45
var max_health
var health
var max_energy
var energy
var gun_pos
var exemptions = []
var closest_object
var next_closest_object
var aim

var owner
var allies
var globals

func _ready():
	globals = get_node("/root/globals")
	owner = globals.terran_base
	max_health = 50 * owner.core
	health = max_health
	max_energy = 50 * owner.engineering
	energy = max_energy
#	payload_modifier = owner.weapons
	gun_pos = self.get_pos()
	effect = preload('res://shared/large_warp.scn')
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	if energy < max_energy:
		energy += owner.engineering * pow(delta, 2)
	allies = get_tree().get_nodes_in_group('terran')
	if fire_delay > 0:
		fire_delay -= 1
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

	var target_pos = Vector2(0, 0)
	var target_distance = 1025
	if closest_object:
		target_pos = closest_object.get_pos()
		aim = gun_pos.angle_to_point(target_pos)
		target_distance = Vector2(target_pos - gun_pos).length()
	if target_distance <= aim_range:
		var offset = deg2rad(closest_object.get_linear_velocity().length())
		if get_rot() < aim - offset:
			set_rot(aim + offset)
		elif get_rot() > aim + offset:
			set_rot(aim - offset)
		else:
			set_rot(aim)
			
	else:
		set_rot(get_rot() + 1 * delta)

	if target_distance <= fire_range:
		if fire_delay <= 0 and energy > .5:
			fire()
			energy -= .25
			fire_delay = fire_rate



func hit_by(obj, shape):
	
	pass
	
	
func death():

	pass
	
	

func fire():
	var taker = effect.instance()
	taker.set_pos(closest_object.get_pos())
	globals.current_map.add_child(taker)
	closest_object.hide()
	var offset
	if next_closest_object:
		aim = gun_pos.angle_to_point(next_closest_object.get_pos())
		offset = deg2rad(next_closest_object.get_linear_velocity().length())
	else:
		randomize()
		aim = get_rot() + deg2rad(rand_range(0, 360))
		offset = 0
	if get_rot() < aim - offset:
		set_rot(aim + offset)
	elif get_rot() > aim + offset:
		set_rot(aim - offset)
	else:
		set_rot(aim)
	closest_object.set_rot(aim)
	var direction = -Vector2(sin(aim), cos(aim))
	var force = closest_object.get_linear_velocity().length()
	closest_object.set_pos(get_pos() + Vector2(direction.normalized() * fire_range))
	var sender = effect.instance()
	sender.set_pos(closest_object.get_pos())
	globals.current_map.add_child(sender)
	if 'projectiles' in closest_object.get_groups():
		PS2D.body_remove_collision_exception(closest_object.get_rid(), closest_object.owner.get_rid())
	closest_object.apply_impulse(Vector2(0, 0), direction * ((force * closest_object.get_mass()) * 2))
	closest_object.show()
	

