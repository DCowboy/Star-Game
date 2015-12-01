
extends RigidBody2D

var name = 'Player'
var max_health = 1
var health = 1
var engage = false
var brake = false
var thrust = 1.5
var inertial_dampener = 0
var rotation = Vector2(0, 0)
var force = Vector2(0,0)
var acceleration = 0
var max_acceleration = 5
var rotate = 0
var shot_count = 0
var fire = false
var fired = true
var fire_delay = 0
var fire_rate = 5
var shields_up = false
var shield_index
var shield_size
var impacts = {}
var shape_hit
#var damaged = false


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		#have player always point to mouse cursor and set that direction for movement
		var mouse_pos = Vector2(event.pos - get_viewport_rect().size / 2)
		rotate = get_viewport_rect().pos.angle_to_point(mouse_pos)
		get_child(0).set_rot(rotate)
		rotation.x = cos(rotate + deg2rad(90))
		rotation.y = -sin(rotate + deg2rad(90))
		
		
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
	shield_index = get_node("shield_shape").get_collision_object_shape_index()
	shield_size = get_shape_transform(shield_index)
	shape_hit = get_shape(0)
	set_fixed_process(true)
	set_process_input(true)


func _fixed_process(delta):
	if fire_delay > 0:
		fire_delay -= 1
	if engage:
		force = rotation.normalized()
		if acceleration < max_acceleration:
			acceleration += thrust * delta
		else: 
			acceleration = max_acceleration

		get_node("hull/burner_left").set_emitting(true)
		get_node("hull/burner_right").set_emitting(true)
	else:
		get_node("hull/burner_left").set_emitting(false)
		get_node("hull/burner_right").set_emitting(false)

	if brake:
		inertial_dampener += sqrt(get_mass()) * delta
		acceleration = 0
	else:
		inertial_dampener = 0
		
	if fire_delay == 0 and fire:
		fire()
		fire = false
		
	if shields_up:
		set_shape_transform(shield_index, shield_size.scaled(Vector2(4, 4)))
		get_node("shield").show()
	else:
		set_shape_transform(shield_index, shield_size)
		get_node("shield").hide()
		



func _integrate_forces(state):
	get_node("/root/globals").rotate = rotate
	get_node("/root/globals").player_pos = get_pos()
	if engage:
		apply_impulse(Vector2(0, 0), force * acceleration)
	set_linear_damp(inertial_dampener)
	
	var count = state.get_contact_count()
	if count > 0:
		var collider = state.get_contact_collider_object(0)
		shape_hit = state.get_contact_local_shape(0)
		if not collider in impacts:
			impacts[collider] = 0
			hit_by(collider, shape_hit)
		
	if impacts != null:
		for each in impacts:
			impacts[each] += 1
			if impacts[each] == 45:
				hit_by(each, shape_hit)
				impacts[each] = 0
				
	if health <= 0:
		death()


func reward(reward):
	print('recieved reward of ' + str(reward))


func hit_by(obj, at=null):
	var shape
	if at != null:
		if at == 0:
			shape = 'hull'
		elif at == 1:
			shape = 'shield'
		print('hit by ' + obj.get_name() + ' on ' + shape)
	pass
	
	
func death():
	#process death
	pass
	
	
func fire():
	#make player have to press button again to shoot again
	fire_delay = fire_rate
	#create shot and send it off
	var shot = get_node("/root/globals").projectile_types.small_laser.instance()
	shot.set_pos(Vector2(0, -get_child(0).get_texture().get_size().height / 2).rotated(rotate) + force)
	shot.set_rot(rotate)
	shot.direction = rotation
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
