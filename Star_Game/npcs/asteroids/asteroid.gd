
extends "res://shared/rigid_object.gd"

var material
var shape
var rotation_speed
export var max_rotation = 5
export var max_acceleration = 100000000
var globals
var owner

func death():
	var crumble
	var number = 0
	var pos = get_pos()
	var description = {}
	if size == 0:
		crumble = globals.explosions.small_rock.instance()
	elif size == 1:
		crumble = globals.explosions.med_rock.instance()
		description['type'] = 'small_roid'
	else:
		crumble = globals.explosions.large_rock.instance()
		description['type'] = 'med_roid'
		
	if size != 0:
		number = int(rand_range(0, 4)) 
		description['material'] = material
		description['size'] = size - 1
		description['shape'] = int(rand_range(0, 3))
		for n in range(number):
			var this_image = get_node('Sprite').get_texture().get_size()
			pos.x += rand_range(-this_image.x * .4, this_image.x * .4)
			pos.y += rand_range(-this_image.y * .4, this_image.y * .4 )
			description['pos'] = pos
			globals.add_entity(description, 1)
	for child in range(get_child_count() -1):
		get_child(child).free()
	crumble.set_pos(get_pos())
	call_deferred('replace_by', crumble)
	globals.population -= 1
	get_node("/root/rewards").reward(self, number)

func _fixed_process(delta):
	
	if abs(get_angular_velocity()) > max_rotation:
		set_angular_damp(1)
	else:
		set_angular_damp(0)
	if get_linear_velocity().length() >  max_acceleration:
		set_linear_damp(1)
	else:
		set_linear_damp(0)

	if health <= 0:
		death()


func _ready():
	globals = get_node("/root/globals")
	owner = self
	build_asteroid()
	rotation_speed = rand_range(-1, 1)
	set_angular_velocity(rotation_speed)	
	var initial_velocity = Vector2(0, 0)
	initial_velocity.x = cos(deg2rad(rand_range(0, 360)))
	initial_velocity.y = -sin(deg2rad(rand_range(0, 360)))
	apply_impulse(Vector2(0, 0), initial_velocity.normalized() * rand_range(0, max_acceleration))
	set_fixed_process(true)


func build_asteroid():
	var size_name
	var material_name
	var unit = get_child(0).get_texture().get_size() / 3
	var region_pos = Vector2(0, 0)
	var health_base
	if self.size == 0:
		size_name = 'small'
	elif self.size == 1:
		size_name = 'medium'
	elif self.size == 2:
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
	get_node("mini_info").lbl_name.get_child(0).set_text(name)
		
	if shape in range(0, 3):
		region_pos.y = unit.y * shape
	else:
	 	print('something is broken with shape')
	get_child(0).set_region_rect(Rect2(region_pos, unit))
	max_health = health_base * (size + 1) + (health_base * shape) * 1.0
	health = max_health
	max_energy = 0.0
	energy = max_energy
	globals.population += 1

	#signal if the collider leaves the body so it doesn't keep hitting
func _on_large_asteroid_body_exit( body ):
	impacts.erase(body)


func _on_medium_asteroid_body_exit( body ):
	impacts.erase(body)


func _on_small_asteroid_body_exit( body ):
	impacts.erase(body)

