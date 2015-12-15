
extends "res://shared/rigid_object.gd"
var controls
var main_cannon
#variables than handle mechanics
var rotate = 0
var engage = false
var force = Vector2(0,0)
var thrust = 5
var acceleration = 0
var max_acceleration = 10
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
	set_fixed_process(true)


func _fixed_process(delta):
	if get_rot() != rotate:
		set_rot(rotate)
	if engage and energy > 0:
		force.x = cos(rotate + deg2rad(90))
		force.y = -sin(rotate + deg2rad(90))
		force = force.normalized()
		if acceleration < max_acceleration:
			acceleration += thrust * delta
		else: 
			acceleration = max_acceleration

		get_node("hull/burner_left").set_emitting(true)
		get_node("hull/burner_right").set_emitting(true)
	else:
		get_node("hull/burner_left").set_emitting(false)
		get_node("hull/burner_right").set_emitting(false)

	if brake and energy > 0:
		if get_linear_velocity().length() > 0:
			energy -= .2
			inertial_dampener += sqrt(get_mass()) * delta
			acceleration = 0
	else:
		inertial_dampener = 0
		
	if fire and energy > .25:
		main_cannon.fire(force, acceleration)
		fire = false
		
	if shields_up and energy > .01:
		set_shape_transform(shield_index, shield_size.scaled(Vector2(4, 4)))
		get_node("shield").show()
		energy -= .01
	else:
		set_shape_transform(shield_index, shield_size)
		get_node("shield").hide()

	get_node("/root/globals").rotate = rotate
	get_node("/root/globals").player_pos = get_pos()
	if engage:
		apply_impulse(Vector2(0, 0), force * acceleration)
		energy -= .01
	set_linear_damp(inertial_dampener)
	
	if health <= 0:
		death()
	
	
func death():
	
	var explode = get_node("/root/globals").explosions.large_normal.instance()
	explode.set_pos(get_pos())
	
	for child in get_children():
		if child.get_name() != 'Camera2D':
			child.free()
	call_deferred('replace_by', explode)
	get_node("/root/spawner").wait(self.name, self.race)
	


func _on_Player_body_exit( body ):
	impacts.erase(body)
	pass # replace with function body


func _on_blue_battle_cruiser_body_exit( body ):
	impacts.erase(body)
	pass # replace with function body
