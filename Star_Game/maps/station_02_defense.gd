
extends RigidBody2D

const type = 'cannon'
const fire_range = 512
const aim_range = 768
var name = 'chentia station defense'
var gun_pos
var exemptions = []
var target
var aim

var owner
var ammo
var shot_count = 0
var fire_delay = 0
var fire_rate = 60
var allies

func _ready():
	gun_pos = self.get_pos()
	ammo = preload('res://npcs/projectiles/large_laser_shot.scn')
	owner = get_node("/root/globals").terran_base
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	allies = get_tree().get_nodes_in_group('terran')
	if fire_delay > 0:
		fire_delay -= 1
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

	var target_pos = Vector2(0, 0)
	var target_distance = 1025
	if target:
		target_pos = target.get_pos()
		aim = gun_pos.angle_to_point(target_pos)
		target_distance = Vector2(target_pos - gun_pos).length()
	if target_distance <= aim_range:
		var offset = deg2rad(5)
		if get_rot() < aim - offset:
			set_rot(aim + offset)
		elif get_rot() > aim + offset:
			set_rot(aim - offset)
		else:
			set_rot(aim)
			
	else:
		set_rot(get_rot() + 1 * delta)

	if target_distance <= fire_range:
		print(target.name)
		fire(0, 0)



func hit_by(obj, shape):
	
	pass
	
	
func death():

	pass
	
	

func fire(force, acceleration):
	if fire_delay <= 0:
		#make player have to press button again to shoot again
		fire_delay = fire_rate
		#fire cost
#		owner.energy -= .25
		#create shot and send it off
		var shot = ammo.instance()
		#there has got to be a better way to set the position correctly
		var weapon_size = get_node('Sprite').get_texture().get_size()
		shot.set_pos(get_global_pos() - Vector2(0, weapon_size.y / 2).rotated(get_rot()))
		shot.set_rot(get_rot())
		shot.direction = Vector2(cos(get_rot() + deg2rad(90)), -sin(get_rot() + deg2rad(90)))
		shot.acceleration = acceleration
		#sets a unique name to later be identified if needed
		shot.set_name(shot.get_name() + ' ' + str(shot_count))
		shot.owner = owner
		add_to_group('object', true)
		get_node("/root/globals").current_map.add_child(shot)
		for object in allies:
			PS2D.body_add_collision_exception(shot.get_rid(),object.get_rid())
		shot_count += 1
		#reset counter to reuse numbers for unique name
		if shot_count >= 25:
			shot_count = 0
	
	
	