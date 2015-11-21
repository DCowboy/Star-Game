
extends RigidBody2D
var mass
var max_health = 0
var health = 0
var engage = false
var brake = false
var thrust = 10
var inertial_dampener = 0
var rotation = Vector2(0, 0)
var direction = Vector2(0, 0)
var acceleration = 0
var velocity = Vector2(0, 0)
var max_acceleration = 25
var rotate = 0
var shot_count = 0
var fire = false
var fired = false
var hit = false
#var damaged = false


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
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
	mass = self.get_mass()
	set_fixed_process(true)
	set_process_input(true)


func _fixed_process(delta):
	if engage:
		direction = rotation
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
		inertial_dampener += sqrt(mass) * delta
		
		if acceleration > 0:
			acceleration -= mass * delta
		else:
			acceleration = 0
		
	velocity = direction.normalized() * acceleration
	
		
	if fire and not fired:
		fire()
		fire = false
		
	get_node("/root/globals").rotate = rotate
	get_node("/root/globals").player_pos = get_pos()


func _integrate_forces(state):
	if get_linear_velocity().length() == 0 or engage:
		inertial_dampener = 0
	set_linear_damp(inertial_dampener)
	apply_impulse(Vector2(0, 0), velocity)



func reward(reward):
	print('recieved reward of ' + str(reward))


func hit_by(obj):
	
	pass
	
	
func death():
	
	pass
	
	
func fire():
	fired = true
	var shot = get_node("/root/globals").projectile_types.small_laser.instance()
	shot.set_pos(Vector2(0, -get_child(0).get_texture().get_size().height / 4).rotated(rotate) + velocity)
	shot.set_rot(rotate)
	shot.direction = rotation
	shot.acceleration = max_acceleration + acceleration
	shot.set_name(shot.get_name() + ' ' + str(shot_count))
	add_to_group('object', true)
	add_child(shot)
	PS2D.body_add_collision_exception(shot.get_rid(),get_rid())
	shot_count += 1
	if shot_count >= 100:
		shot_count = 0