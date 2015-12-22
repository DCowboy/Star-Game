
extends "res://shared/rigid_object.gd"

const type = 'ship'
var owner
var controls
var size_name
var variation
var variation_name
var status
var cargo
var rotate
var force_direction = Vector2(0, 0)
var facing_direction = Vector2(0, 0)
var engage = false
var engineering_extensions = {}
var burners = []
var base_thrust
var previous_pos = Vector2(0, 0)
var current_pos = Vector2(0, 0)
var speed = 0
var brake = false
var core_extensions = {}
var inertial_dampener = 0
var fire = false
var weapons = {}
var current_weapon
var shields_up = false
var shield_size

var defenses = {}
var tactical_extensions = {}
var supply_extensions = {}




func _ready():
	rotate = 0

	set_fixed_process(true)

	pass


func _fixed_process(delta):
	previous_pos = current_pos
	current_pos = get_pos()
	speed = Vector2(previous_pos - current_pos).length() / 0.0167
	
	if get_rot() != rotate:
		set_rot(rotate)
	if engage and energy > .01:
		force_direction.x = cos(rotate + deg2rad(90))
		force_direction.y = -sin(rotate + deg2rad(90))
		force_direction = force_direction.normalized()

		if speed <= 1000 or force_direction.dot(facing_direction) <= 0:
			apply_impulse(Vector2(0, 0), force_direction * base_thrust * delta)
			energy -= .01
			engines_engage()
			facing_direction = force_direction
		else:
			engines_disengage()
		
		
	else:
		engines_disengage()

	if brake and energy >= 0.2:
		if get_linear_velocity().length() > 0:
			energy -= .2
			inertial_dampener += sqrt(get_mass()) * delta

	else:
		inertial_dampener = 0
		
	if fire and energy >= .25:
		current_weapon.fire(force_direction, get_linear_velocity().length())
		fire = false
	else:
		fire = false

	if shields_up and energy > .01:
		set_shape_transform(shield_index, shield_size.scaled(Vector2(4, 4)))
		get_node("shield").show()
		energy -= .01
	else:
		set_shape_transform(shield_index, shield_size)
		get_node("shield").hide()

	set_linear_damp(inertial_dampener)
	get_node("/root/globals").player_speed = speed
	get_node("/root/globals").rotate = rotate
	get_node("/root/globals").player_pos = get_pos()
	
	if health <= 0:
		death()


func engines_engage():
	for burner in burners:
		burner.set_emitting(true)
	
func engines_disengage():
	for burner in burners:
		burner.set_emitting(false)


func death():
	
	var explode = get_node("/root/globals").explosions.large_normal.instance()
	explode.set_pos(get_pos())
	
	for child in get_children():
		if child.get_name() != 'Camera2D':
			child.free()
	call_deferred('replace_by', explode)
	get_node("/root/rewards").reward(self)
	get_node("/root/spawner").wait(owner, race)

