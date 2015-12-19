
extends "res://shared/rigid_object.gd"
var controls
var main_cannon
#variables than handle mechanics
var rotate = 0
var engage = false
var force = Vector2(0,0)
var thrust = 1000
var direction
var last_pos 
var this_pos
var speed = 0
var brake = false
var inertial_dampener = 0
var fire = false
var fired = true
var shields_up = false
var shield_size


func _ready():
	name = 'Player'
	race = 'terran'
	type = 'ship'
	max_health = 100.0
	health = max_health
	max_energy = 100.0
	energy = max_energy
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	add_child(preload("player_control.gd").new())
	main_cannon = get_node("hull/main_cannon/laser_cannon")
	shield_strength = 10
	last_pos = get_pos()
	this_pos = get_pos()
	set_fixed_process(true)


func _fixed_process(delta):
	last_pos = this_pos
	this_pos = get_pos()
	
	speed = Vector2(last_pos - this_pos).length() / 0.0167
	if get_rot() != rotate:
		set_rot(rotate)
	if engage and energy > .01:
		force.x = cos(rotate + deg2rad(90))
		force.y = -sin(rotate + deg2rad(90))
		force = force.normalized()

		if speed <= 1000 or force.dot(direction) <= 0:
			apply_impulse(Vector2(0, 0), force * thrust * delta)
			energy -= .01
			get_node('hull').engines_engage()
			direction = force
		else:
			get_node('hull').engines_disengage()
		
		
	else:
		get_node('hull').engines_disengage()
		pass

	if brake and energy >= 0.2:
		if get_linear_velocity().length() > 0:
			energy -= .2
			inertial_dampener += sqrt(get_mass()) * delta

	else:
		inertial_dampener = 0
		
	if fire and energy >= .25:
		main_cannon.fire(force, get_linear_velocity().length())
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
	
	
func death():
	
	var explode = get_node("/root/globals").explosions.large_normal.instance()
	explode.set_pos(get_pos())
	
	for child in get_children():
		if child.get_name() != 'Camera2D':
			child.free()
	call_deferred('replace_by', explode)
	get_node("/root/rewards").reward(self)
	get_node("/root/spawner").wait(self.name, self.race)
	


func _on_Player_body_exit( body ):
	impacts.erase(body)
	pass # replace with function body


func _on_blue_battle_cruiser_body_exit( body ):
	impacts.erase(body)
	pass # replace with function body
