
extends RigidBody2D

var size
var material
var shape
var rotation_speed
export var max_rotation = 5
export var max_acceleration = 500
var health_base
var max_health
var health


func death():
	var crumble
	if size == 0:
		crumble = get_node("/root/globals").explosions.small_rock.instance()
	elif size == 1:
		crumble = get_node("/root/globals").explosions.med_rock.instance()
	else:
		crumble = get_node("/root/globals").explosions.large_rock.instance()
	for child in range(get_child_count() -1):
		get_child(child).free()
	
	crumble.set_pos(get_pos())
	self.replace_by(crumble)


func hit_by(obj):
	var reward = health
		
	if obj.get_type() == 'KinematicBody2D':
		health -=  obj.payload
		if health <= 0:
			health = 0
	elif str(obj.get_name()).find('asteroid') != -1:
		if obj.get_mass() > get_mass():
			health += (obj.get_mass() + get_mass()) / 2.5
		if health > max_health:
			health = max_health
	else:
		if get_mass() > obj.get_mass():
			health -= ceil((get_mass() - obj.get_mass()) / 2)
		else:
			health -= rand_range(2, obj.get_mass() / 2)
	if health < reward:
		reward -= health
		if obj.get_type() == 'KinematicBody2D':
			obj.get_parent().reward(int(reward))
		else:
			obj.reward(reward)


func reward(amount):
	
	pass


func _integrate_forces(state):
	if abs(get_angular_velocity()) > max_rotation:
		set_angular_damp(1)
	else:
		set_angular_damp(0)
	if get_linear_velocity().length() >  max_acceleration:
		set_linear_damp(1)
	else:
		set_linear_damp(0)

	var hits = get_colliding_bodies()
	for hit in hits:
		hit_by(hit)
	if health <= 0:
		death()


func _ready():
	rotation_speed = rand_range(-1, 1)
	set_angular_velocity(rotation_speed)
	if get_name() == 'large_asteroid':
		size = 2
	elif get_name() == 'medium_asteroid':
		size = 1
	else:
		size = 0
		
	var unit = get_child(0).get_texture().get_size() / 3
	var region_pos = Vector2(0, 0)
	if material == 0:
		health_base = int(rand_range(13, 25))
		region_pos.x = unit.x * 2
	elif material == 1:
		health_base = int(rand_range(26, 50))
		region_pos.x = unit.x * 1
	else:
		health_base = int(rand_range(65, 125))
		region_pos.x = unit.x * 0
	region_pos.y = unit.y * shape
	get_child(0).set_region_rect(Rect2(region_pos, unit))
	max_health = health_base * (size + 1) + (health_base * shape)
	health = max_health
	add_to_group('object', true)

	var initial_velocity = Vector2(0, 0)
	initial_velocity.x = cos(deg2rad(rand_range(0, 360)))
	initial_velocity.y = -sin(deg2rad(rand_range(0, 360)))
	apply_impulse(Vector2(0, 0), initial_velocity.normalized() * rand_range(0, max_acceleration))






