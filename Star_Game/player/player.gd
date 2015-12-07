
extends "res://shared/rigid_object.gd"
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
var shot_count = 0
var fire_delay = 0
var fire_rate = 5
var shield_index
var shields_up = false
var shield_size


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		#have player always point to mouse cursor and set that direction for movement
		var mouse_pos = Vector2(event.pos - get_viewport_rect().size / 2)
		rotate = get_viewport_rect().pos.angle_to_point(mouse_pos)
		get_child(0).set_rot(rotate)
		force.x = cos(rotate + deg2rad(90))
		force.y = -sin(rotate + deg2rad(90))
		
	if event.is_action("accelerate"):
		if event.is_pressed():
			if not shields_up:
				engage = true
		else:
			engage = false
	elif event.is_action("decelerate"):
		if event.is_pressed():
			brake = true
		else:
			brake = false
	
	if event.is_action("fire"):
		if event.is_pressed():
			if not shields_up:
				fire = true
	elif event.is_action("shields"):
		if event.is_pressed():
			if not engage:
				shields_up = true
		else:
			if shields_up:
				shields_up = false


func _ready():
	name = 'Player'
	race = 'blue'
	max_health = 100.0
	health = max_health
	max_energy = 100.0
	energy = max_energy
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	shield_strength = 10
	set_fixed_process(true)
	set_process_input(true)


func _fixed_process(delta):
	if fire_delay > 0:
		fire_delay -= 1
	if engage and energy > 0:
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
		
	if fire_delay == 0 and fire and energy > 0:
		fire()
		fire = false
		
	if shields_up and energy > 0:
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
	for child in range(get_child_count() -1):
		get_child(child).queue_free()
	call_deferred('replace_by', explode)
	get_node("/root/spawner").wait(self.name, self.race)


func fire():
	energy -= .25
	#make player have to press button again to shoot again
	fire_delay = fire_rate
	#create shot and send it off
	var shot = get_node("/root/globals").projectile_types.small_laser.instance()
	shot.set_pos(Vector2(0, -get_child(0).get_texture().get_size().height / 2).rotated(rotate))
	shot.set_rot(rotate)
	shot.direction = force
	shot.acceleration = get_linear_velocity().length() + thrust
	#sets a unique name to later be identified if needed
	shot.set_name(shot.get_name() + ' ' + str(shot_count))
	add_to_group('object', true)
	add_child(shot)
	PS2D.body_add_collision_exception(shot.get_rid(),get_rid())
	shot_count += 1
	#reset counter to reuse numbers for unique name
	if shot_count >= 25:
		shot_count = 0


func _on_Player_body_exit( body ):
	impacts.erase(body)
	pass # replace with function body
