
extends RigidBody2D
var mass
var engage = false
var brake = false
export var thrust = 10
var inertial_dampener = 0
var direction = Vector2(0, 0)
var acceleration = 0
var velocity = Vector2(0, 0)
export var max_acceleration = 50
var rotate = 0
var ammo
var fire = false
var fired = false
var hit = false


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		var mouse_pos = Vector2(event.pos.x - get_viewport_rect().size.width / 2, event.pos.y - get_viewport_rect().size.height / 2)
		rotate = get_viewport_rect().pos.angle_to_point(mouse_pos)
		get_child(0).set_rot(rotate)
		
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
			
			
func fire():
	fired = true
	var shot = ammo.instance()
	shot.set_pos(Vector2(0, -get_child(0).get_texture().get_size().height * .75).rotated(rotate) + velocity)
	shot.set_rot(rotate)
	shot.set('direction', direction)
	shot.set('acceleration', max_acceleration + acceleration)
	add_child(shot)


func _process(delta):
	direction.x = cos(rotate + deg2rad(90))
	direction.y = -sin(rotate + deg2rad(90))
	
	if (engage == true):
		if get_linear_damp() != 0:
			inertial_dampener = 0

		if acceleration < max_acceleration:
			acceleration += thrust * delta
		else: 
			acceleration = max_acceleration
		apply_impulse(Vector2(0, 0), velocity)
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
	set_linear_damp(inertial_dampener)
	
	
	if fire and not fired:
		fire()
		fire = false

func _ready():
	mass = self.get_mass()
	ammo = preload('res://npcs/projectiles/laser_shot.scn')
	set_process(true)
	set_process_input(true)
	
func hit(obj):
	pass