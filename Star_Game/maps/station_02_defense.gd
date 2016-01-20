
extends RigidBody2D

const type = 'cannon'
const fire_range = 512
const aim_range = 768
var name = 'chentia station defense'
var payload = 50
var max_health
var health
var max_energy
var energy
var gun_pos
var exemptions = []
var target
var aim

var owner
var ammo
var shot_count = 0
var fire_delay = 0
var fire_rate = 30

var allies

func _ready():
	owner = get_node("/root/globals").chentia_base
	max_health = 50 * owner.core
	health = max_health
	max_energy = 50 * owner.engineering
	energy = max_energy
	payload *= owner.weapons
	gun_pos = self.get_pos()
	ammo = preload('res://npcs/projectiles/large_laser_shot.scn')
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	if energy < max_energy:
		energy += owner.engineering * pow(delta, 2)
	allies = get_tree().get_nodes_in_group('chentia')
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
	if target != null:
		target_pos = target.get_pos()
		aim = gun_pos.angle_to_point(target_pos)
		target_distance = Vector2(target_pos - gun_pos).length()
	if target_distance <= aim_range:
		var offset = deg2rad(target.get_linear_velocity().length())
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
			fire(0)
			energy -= .25
			fire_delay = fire_rate
		target = null



func hit_by(obj, shape):
	
	pass
	
	
func death():

	pass
	
	

func fire(acceleration):
	#create shot and send it off
	var shot = ammo.instance()
	#there has got to be a better way to set the position correctly
	var weapon_size = get_node('Sprite').get_texture().get_size()
	shot.set_pos(get_global_pos() - Vector2(0, weapon_size.y / 2).rotated(get_rot()))
	shot.origin = shot.get_pos()
	shot.set_rot(get_rot())
	shot.direction = Vector2(cos(get_rot() + deg2rad(90)), -sin(get_rot() + deg2rad(90)))
	shot.acceleration = acceleration
	#sets a unique name to later be identified if needed
	shot.set_name(shot.get_name() + ' ' + str(shot_count))
	shot.owner = owner
	shot.fire_range = fire_range
	shot.payload = payload
	add_to_group('object', true)
	get_node("/root/globals").current_map.add_child(shot)
	for object in allies:
		PS2D.body_add_collision_exception(shot.get_rid(),object.get_rid())
	shot_count += 1
	#reset counter to reuse numbers for unique name
	if shot_count >= 25:
		shot_count = 0

	
	