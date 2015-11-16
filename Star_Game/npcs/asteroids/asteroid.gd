
extends RigidBody2D

var size
var material
var shape
var rotation_speed
export var max_rotation = 5
export var max_acceleration = 50
var damaged = false
var max_health
var health

func hit(obj):
	damaged = true
	pass


func _integrate_forces(state):
	var hits = get_colliding_bodies()
	for hit in hits:
		hit(hit)
	if abs(get_angular_velocity()) > max_rotation:
		set_angular_damp(1)
	else:
		set_angular_damp(0)
	if get_linear_velocity().length() >  max_acceleration:
		set_linear_damp(1)
	else:
		set_linear_damp(0)



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
	if material == 'normal':
		region_pos.x = unit.x * 2
	elif material == 'ore':
		region_pos.x = unit.x * 1
	else:
		region_pos = unit.x * 0
	
	region_pos.y = unit.y * shape
	get_child(0).set_region_rect(Rect2(region_pos, unit))
	var initial_velocity = Vector2(0, 0)
	initial_velocity.x = 0
	initial_velocity.y = 0
	set_linear_velocity(initial_velocity)