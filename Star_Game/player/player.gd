
extends RigidBody2D
var max_health = 0
var health = 0
var engage = false
var brake = false
var thrust = .5
var inertial_dampener = 0
var rotation = Vector2(0, 0)
var force = Vector2(0,0)
var acceleration = 0
var max_acceleration = 5
var rotate = 0
var shot_count = 0
var fire = false
var fired = false
var hit = false
#var damaged = false


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		#have player always point to mouse cursor and set that direction for movement
		var mouse_pos = Vector2(event.pos.x - get_viewport_rect().size.width / 2, event.pos.y - get_viewport_rect().size.height / 2)
		rotate = get_viewport_rect().pos.angle_to_point(mouse_pos)
		get_child(0).set_rot(rotate)
		rotation.x = cos(rotate + deg2rad(90))
		rotation.y = -sin(rotate + deg2rad(90))
		
		
	if event.is_action("accelerate"):
		if event.is_pressed():
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
			fire = true
		else:
			fired = false
			
			
func _ready():
	set_fixed_process(true)
	set_process_input(true)


func _fixed_process(delta):
	if engage:
		force = rotation.normalized()
		if acceleration < max_acceleration:
			acceleration += thrust * delta
		else: 
			acceleration = max_acceleration

		get_node("Sprite/burner_left").set_emitting(true)
		get_node("Sprite/burner_right").set_emitting(true)
	else:
		get_node("Sprite/burner_left").set_emitting(false)
		get_node("Sprite/burner_right").set_emitting(false)

	if brake:
		inertial_dampener += sqrt(get_mass()) * delta
		acceleration = 0
	else:
		inertial_dampener = 0
		
	if fire and not fired:
		fire()
		fire = false
		
	get_node("/root/globals").rotate = rotate
	get_node("/root/globals").player_pos = get_pos()


func _integrate_forces(state):
	if engage:
		apply_impulse(Vector2(0, 0), force * acceleration)
	set_linear_damp(inertial_dampener)


func reward(reward):
	print('recieved reward of ' + str(reward))


func hit_by(obj):
	#process info when hit
	pass
	
	
func death():
	#process death
	pass
	
	
func fire():
	#make player have to press button again to shoot again
	fired = true
	#create shot and send it off
	var shot = get_node("/root/globals").projectile_types.small_laser.instance()
	shot.set_pos(Vector2(0, -get_child(0).get_texture().get_size().height / 4).rotated(rotate) + force)
	shot.set_rot(rotate)
	shot.direction = rotation
	shot.acceleration = thrust + force.length()
	#sets a unique name to later be identified if needed
	shot.set_name(shot.get_name() + ' ' + str(shot_count))
	add_to_group('object', true)
	add_child(shot)
	PS2D.body_add_collision_exception(shot.get_rid(),get_rid())
	shot_count += 1
	#reset counter to reuse numbers for unique name
	if shot_count >= 25:
		shot_count = 0