
extends RigidBody2D

var size
var material
var shape
var name
var rotation_speed
export var max_rotation = 5
export var max_acceleration = 500
var impacts = {}

var max_health
var health
var max_energy = 0
var energy = 0


func death():
	var crumble
	var pos = get_pos()
	var description = {}
	if size == 0:
		crumble = get_node("/root/globals").explosions.small_rock.instance()
	elif size == 1:
		crumble = get_node("/root/globals").explosions.med_rock.instance()
		description['type'] = 'small_roid'
	else:
		crumble = get_node("/root/globals").explosions.large_rock.instance()
		description['type'] = 'med_roid'
		
	if size != 0:
		var number = int(rand_range(1, 4)) 
		description['material'] = material
		description['size'] = size - 1
		description['shape'] = int(rand_range(0, 3))
		for n in range(number):
			pos.x += rand_range(-get_child(0).get_texture().get_size().width * .4, get_child(0).get_texture().get_size().width * .4)
			pos.y += rand_range(-get_child(0).get_texture().get_size().height * .4, get_child(0).get_texture().get_size().height * .4 )
			description['pos'] = pos
			get_node("/root/globals").add_entity(description, 1)
	for child in range(get_child_count() -1):
		get_child(child).free()
	crumble.set_pos(get_pos())
	self.call_deferred('replace_by', crumble)


func hit_by(obj):
	var reward = health
		
	if obj.name == 'laser_shot':
		health -=  obj.payload
		if health <= 0:
			health = 0
	elif 'material' in obj:
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
		if obj.name == 'laser_shot':
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

	
	var count = state.get_contact_count()
	if count > 0:
		for hit in range(count):
			var collider = state.get_contact_collider_object(hit)
			if not collider in impacts and str(collider.get_name()).find('laser_shot') == -1:
				impacts[collider] = 0
				hit_by(collider)

	if impacts != null:
		for each in impacts:
			impacts[each] += 1
			if impacts[each] == 45:
				hit_by(each)
				impacts[each] = 0
	

	if health <= 0:
		death()


func _ready():
	build_asteroid()
	rotation_speed = rand_range(-1, 1)
	set_angular_velocity(rotation_speed)	
	var initial_velocity = Vector2(0, 0)
	initial_velocity.x = cos(deg2rad(rand_range(0, 360)))
	initial_velocity.y = -sin(deg2rad(rand_range(0, 360)))
	apply_impulse(Vector2(0, 0), initial_velocity.normalized() * rand_range(0, max_acceleration))


func build_asteroid():
	var size_name
	var material_name
	var unit = get_child(0).get_texture().get_size() / 3
	var region_pos = Vector2(0, 0)
	var health_base
	if size == 0:
		size_name = 'small'
		
	elif size == 1:
		size_name = 'medium'
	elif size == 2:
		size_name = 'large'
	else:
		print('something is broken with size')
	
	if material == 0:
		health_base = int(rand_range(65, 125))
		region_pos.x = unit.x * 0
		material_name = 'solid'
	elif material == 1:
		health_base = int(rand_range(26, 50))
		region_pos.x = unit.x * 1
		material_name = 'rusty'
	elif material == 2:
		health_base = int(rand_range(13, 25))
		region_pos.x = unit.x * 2
		material_name = 'rocky'
	else: 
		print('something is broken with material')
	name = size_name + " " + material_name + " asteroid"
	get_node("mini_info").lbl_name.set_text(name)
		
	if shape in range(0, 3):
		region_pos.y = unit.y * shape
	else:
	 	print('something is broken with shape')
	get_child(0).set_region_rect(Rect2(region_pos, unit))
	max_health = health_base * (size + 1) + (health_base * shape) * 1.0
	health = max_health

	#signal if the collider leaves the body so it doesn't keep hitting
func _on_large_asteroid_body_exit( body ):
	impacts.erase(body)



func _on_medium_asteroid_body_exit( body ):
	impacts.erase(body)

	

func _on_small_asteroid_body_exit( body ):
	impacts.erase(body)

